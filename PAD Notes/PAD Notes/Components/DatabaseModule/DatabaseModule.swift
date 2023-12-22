//
//  DatabaseModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

protocol DatabaseModuleProtocol {
    func configure()
}

protocol NotesListDatabaseProtocol {
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion)
    func deleteNotes(noteIDs:[String], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion)
}

protocol NoteDatabaseProtocol {
    func deleteNote(_ noteID: String, completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion)
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
}

struct NoteModel: Codable {
    let UID: String
    let NoteID: String
    var Title: String
    var Content: String
    let CreatedAt: Date
    var UpdatedAt: Date
    var IsFavorite: Bool
    var IsShared: Bool
    
    init(UID: String, NoteID: String, Title: String, Content: String, CreatedAt: Date, UpdatedAt: Date, IsFavorite: Bool = false, IsShared: Bool = true) {
        self.UID = UID
        self.NoteID = NoteID
        self.Title = Title
        self.Content = Content
        self.CreatedAt = CreatedAt
        self.UpdatedAt = UpdatedAt
        self.IsFavorite = IsFavorite
        self.IsShared = IsShared
    }
}

extension NoteModel {
    init(userID: String, title: String, content: String) {
        self.init(UID: userID, NoteID: UUID().uuidString, Title: title, Content: content, CreatedAt: Date(), UpdatedAt: Date())
    }
}

class DatabaseModule: DatabaseModuleProtocol {
    typealias NotesListDatabaseCompletion = (Result<[NoteModel], Error>) -> Void
    typealias DeleteNotesDatabaseCompletion = (Error?) -> Void
    typealias AddUpdateNoteDatabaseCompletion = (Result<NoteModel, Error>) -> Void
    
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = DatabaseModule()
    
    func configure() {
        
    }
}

extension DatabaseModule: NotesListDatabaseProtocol {
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        // FIXME:
        completion(.success([
            NoteModel(UID: "12321", NoteID: "123123", Title: "Test Tittle 1", Content: String(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false),
            NoteModel(UID: "12321", NoteID: "123124", Title: "Test Tittle 2", Content: String(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false),
            NoteModel(UID: "12321", NoteID: "123125", Title: "Test Tittle 3", Content: String(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false)]))
    }
    
    func deleteNotes(noteIDs NoteIDs:[String], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion) {
        // FIXME:
        completion(nil)
    }
}

extension DatabaseModule: NoteDatabaseProtocol {
    func deleteNote(_ noteID: String, completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion) {
        // FIXME:
        completion(nil)
    }
    
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        let note = NoteModel.init(userID: userID, title: title, content: content)
        self.addNewNote(note, completion: completion)
    }
    
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        // FIXME:
        // update UpdatedAt property
        var updatedNote = note
        updatedNote.UpdatedAt = Date()
        
        completion(.success(updatedNote))
    }
    
    func favoriteNote(_ note: NoteModel, isFavorite: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        var updatedNote = note
        updatedNote.IsFavorite = isFavorite
        
        self.updateNote(note, completion: completion)
    }
    
    func sharedNote(_ note: NoteModel, isShared: Bool, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        var updatedNote = note
        updatedNote.IsShared = isShared
        
        self.updateNote(note, completion: completion)
    }
    
    // MARK: private functions
    func addNewNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        // FIXME:
        completion(.success(note))
    }
}
