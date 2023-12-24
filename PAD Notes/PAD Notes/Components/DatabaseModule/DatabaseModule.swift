//
//  NoteDatabaseModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

// MARK: protocol NoteDatabaseModuleProtocol
/// protocol NoteDatabaseModuleProtocol
protocol NoteDatabaseModuleProtocol {
    /// Configure/ setup something
    func configure(firDBRef: RealtimeDatabaseFirebaseModuleProtocol)
}

// MARK: protocol NotesListDatabaseProtocol
/// protocol NotesListDatabaseProtocol
/// List functions for list notes
protocol NotesListDatabaseProtocol {
    /// Query all notes by user
    ///
    /// - parameters userId: the user ID who will queried from database
    /// - parameter completion: the call back result with format (Result<[NoteModel], Error>)
    func queryNotesByUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion)
    
    /// Query all shared notes and exclude notes of user
    /// - parameter userId: the user ID who is excluded from the clolletion shared notes
    /// - parameter completion: the call back result with format (Result<[NoteModel], Error>)
    func querySharedNotesExcludeUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion)
    
    /// Delete list of notes
    /// - parameter notes: the list notes will be deleted
    /// - parameter completion: the call back result of deleted notes with format ([NoteModel]).
    func deleteNotes(notes:[NoteModel], completion: @escaping NoteDatabaseModule.DeleteNotesDatabaseCompletion)
}

// MARK: protocol NoteDetailDatabaseProtocol
/// protocol NoteDetailDatabaseProtocol
/// List functions for one note
protocol NoteDetailDatabaseProtocol {
    /// Add a new note to database
    /// - parameter userID: the user ID who owns/ creates the note
    /// - parameter title: the title of the note
    /// - parameter content: the content of the note
    /// - parameter completion: the call back result with format (Result<NoteModel, Error>). It means the adding note is success if we have a new note ad no error.
    func addNewNote(userID: String, title: String, content: String, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion)
    
    /// Update note
    /// - parameter note: the updating note will be updated to database
    /// - parameter completion: the call back result with format (Result<NoteModel, Error>). It means the updating note is success if we have a updated note ad no error.
    func updateNote(_ note: NoteModel, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion)
    
    /// Favorite or unfavorite the note
    /// - parameter note: the note will be favorite or unfavorite
    /// - parameter isFavorite: true -> favorite and false -> unfavorite
    /// - parameter completion: the call back result with format (Result<NoteModel, Error>). It means the updating note is success if we have a updated note ad no error.
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion)
    
    /// Share or unshare the note to other
    /// - parameter note: the note will be share or unshare
    /// - parameter isShared: true -> share and false -> unshare
    /// - parameter completion: the call back result with format (Result<NoteModel, Error>). It means the updating note is success if we have a updated note ad no error.
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion)
    
    /// Delete the note from database
    /// - parameter note: the note will be deleted
    /// - parameter completion: the call back result with format (Error?). It means the deleting note is success if we don't have any error.
    func deleteNote(_ note: NoteModel, completion: @escaping NoteDatabaseModule.DeleteNoteDatabaseCompletion)
}

///  Class NoteDatabaseModule
class NoteDatabaseModule: NoteDatabaseModuleProtocol {
    typealias NotesListDatabaseCompletion = (Result<[NoteModel], Error>) -> Void
    typealias DeleteNotesDatabaseCompletion = ([NoteModel]) -> Void
    typealias DeleteNoteDatabaseCompletion = (Error?) -> Void
    typealias AddUpdateNoteDatabaseCompletion = (Result<NoteModel, Error>) -> Void
    
    /// a shared instance of NoteDatabaseModule as singleton instance
    static let sharedInstance = NoteDatabaseModule()
    private var firDBRef: RealtimeDatabaseFirebaseModuleProtocol!
    
    private let rootChild = "note"

    func configure(firDBRef: RealtimeDatabaseFirebaseModuleProtocol) {
        self.firDBRef = firDBRef
        self.firDBRef.configure()
    }
}

// MARK: Conforming NotesListDatabaseProtocol
/// Conforming NotesListDatabaseProtocol
extension NoteDatabaseModule: NotesListDatabaseProtocol {
    func queryNotesByUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion) {
        self.firDBRef.get(at: userId, parentNodes: rootChild) { result in
            switch result {
                /**
                 The scheme of note database
                 note:
                    { userId:
                        [ NoteId:
                            { title
                            content
                            createdAt
                            updatedAt
                            isFavorite
                            isShared } ]
                 */
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
    
    func querySharedNotesExcludeUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion) {
        self.firDBRef.get(at: rootChild, parentNodes: []) { result in
            switch result {
                /**
                 The scheme of note database
                 note:
                    { userId:
                        [ NoteId:
                            { title
                            content
                            createdAt
                            updatedAt
                            isFavorite
                            isShared } ]
                 */
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
    
    func deleteNotes(notes:[NoteModel], completion: @escaping NoteDatabaseModule.DeleteNotesDatabaseCompletion) {
        // create dispatch group
        let dispatchNotesGroup = DispatchGroup()
        var removedNotes = [NoteModel]()
        for note in notes {
            dispatchNotesGroup.enter()
            self.deleteNote(note) { error in
                if error == nil {
                    removedNotes.append(note)
                }
                dispatchNotesGroup.leave()
            }
        }
        
        dispatchNotesGroup.notify(queue: DispatchQueue.main) {
            completion(removedNotes)
        }
    }
}

// MARK: Conforming NotesListDatabaseProtocol
/// Conforming NotesListDatabaseProtocol
extension NoteDatabaseModule: NoteDetailDatabaseProtocol {
    func addNewNote(userID: String, title: String, content: String, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion) {
        let note = NoteModel.init(userID: userID, title: title, content: content)
        self.addNewNote(note, completion: completion)
    }
    
    func updateNote(_ note: NoteModel, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion) {
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
    
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion) {
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
    
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion) {
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
    
    func deleteNote(_ note: NoteModel, completion: @escaping NoteDatabaseModule.DeleteNoteDatabaseCompletion) {
        self.firDBRef.delete(at: note.NoteID, parentNodes: rootChild, note.UID) { error in
            completion(error)
        }
    }
    
    // MARK: private functions
    /// Add a new note to database
    /// - parameter note: the note will be added to database
    /// - parameter completion: the call back result with format (Result<NoteModel, Error>). It means the adding note is success if we have a new note ad no error.
    private func addNewNote(_ note: NoteModel, completion: @escaping NoteDatabaseModule.AddUpdateNoteDatabaseCompletion) {
        self.firDBRef.set(note.dictionaryNote(), at: note.NoteID, parentNodes: rootChild, note.UID) { error in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(note))
            }
        }
    }
}
