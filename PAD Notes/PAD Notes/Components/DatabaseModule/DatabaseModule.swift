//
//  DatabaseModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

protocol DatabaseModuleProtocol {
    func configure(firDBRef: RealtimeDatabaseFirebaseModuleProtocol)
}

protocol NotesListDatabaseProtocol {
    func queryNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion)
    func querySharedNotesExcludeUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion)
    func deleteNotes(notes:[NoteModel], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion)
}

protocol NoteDatabaseProtocol {
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func deleteNote(_ note: NoteModel, completion: @escaping DatabaseModule.DeleteNoteDatabaseCompletion)
}

//
class DatabaseModule: DatabaseModuleProtocol {
    typealias NotesListDatabaseCompletion = (Result<[NoteModel], Error>) -> Void
    typealias DeleteNotesDatabaseCompletion = ([NoteModel]) -> Void
    typealias DeleteNoteDatabaseCompletion = (Error?) -> Void
    typealias AddUpdateNoteDatabaseCompletion = (Result<NoteModel, Error>) -> Void
    
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = DatabaseModule()
    private var firDBRef: RealtimeDatabaseFirebaseModuleProtocol!
    
    private let rootChild = "note"

    func configure(firDBRef: RealtimeDatabaseFirebaseModuleProtocol) {
        self.firDBRef = firDBRef
        self.firDBRef.configure()
    }
}

extension DatabaseModule: NotesListDatabaseProtocol {
    func queryNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        self.firDBRef.get(at: userId, parentNodes: rootChild) { result in
            switch result {
            case .success(let dataSnapshot):
                var arrNotes = [NoteModel]()
                if let data = dataSnapshot.value as? NSDictionary {
                    if let noteIDs = data.allKeys as? Array<Any> {
                        for noteID in noteIDs {
                            arrNotes.append(NoteModel(userID: userId, noteID: noteID as! String, dictValue: data[noteID] as! [String : Any]))
                        }
                    }
                }
                
                completion(.success(arrNotes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func querySharedNotesExcludeUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        self.firDBRef.get(at: rootChild, parentNodes: []) { result in
            switch result {
            case .success(let dataSnapshot):
                print(dataSnapshot)
                var arrNotes = [NoteModel]()
                if let dataRoot = dataSnapshot.value as? NSDictionary {
                    if let uIDs = dataRoot.allKeys as? Array<Any> {
                        for uID in uIDs {
                            if let dataByUser = dataRoot[uID] as? NSDictionary {
                                if let noteIDs = dataByUser.allKeys as? Array<Any> {
                                    for noteID in noteIDs {
                                        arrNotes.append(NoteModel(userID: uID as! String, noteID: noteID as! String, dictValue: dataByUser[noteID] as! [String : Any]))
                                    }
                                }
                            }
                        }
                    }
                }
                
                completion(.success(arrNotes.filter{ $0.UID != userId }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteNotes(notes:[NoteModel], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion) {
        let dispatchGroup = DispatchGroup()
        var removedNotes = [NoteModel]()
        for note in notes {
            dispatchGroup.enter()
            self.deleteNote(note) { error in
                if error == nil {
                    removedNotes.append(note)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(removedNotes)
        }
    }
}

extension DatabaseModule: NoteDatabaseProtocol {
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        let note = NoteModel.init(userID: userID, title: title, content: content)
        self.addNewNote(note, completion: completion)
    }
    
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        // update UpdatedAt property
        var updatedNote = note
        updatedNote.UpdatedAt = Date()
        
        self.firDBRef.set(updatedNote.dictionaryNote(), at: updatedNote.NoteID, parentNodes: rootChild, updatedNote.UID) { error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(updatedNote))
            }
        }
    }
    
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        var updatedNote = note
        updatedNote.IsFavorite = isFavorite
        updatedNote.UpdatedAt = Date()
        
        self.firDBRef.set(updatedNote.IsFavorite.description, at: NoteModel.Properties.IsFavorite.stringValue, parentNodes: rootChild, updatedNote.UID, updatedNote.NoteID) { error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(updatedNote))
            }
        }
    }
    
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        var updatedNote = note
        updatedNote.IsShared = isShared
        updatedNote.UpdatedAt = Date()
        
        self.firDBRef.set(updatedNote.IsShared.description, at: NoteModel.Properties.IsShared.stringValue, parentNodes: rootChild, updatedNote.UID, updatedNote.NoteID) { error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(updatedNote))
            }
        }
    }
    
    func deleteNote(_ note: NoteModel, completion: @escaping DatabaseModule.DeleteNoteDatabaseCompletion) {
        self.firDBRef.delete(at: note.NoteID, parentNodes: rootChild, note.UID) { error in
            completion(error)
        }
    }
    
    // MARK: private functions
    private func addNewNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        self.firDBRef.set(note.dictionaryNote(), at: note.NoteID, parentNodes: rootChild, note.UID) { error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(note))
            }
        }
    }
}


