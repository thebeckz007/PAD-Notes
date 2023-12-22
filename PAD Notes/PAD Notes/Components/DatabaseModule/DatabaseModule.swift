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
}

struct NoteModel: Codable {
    let UID: String
    let NoteID: String
    let Title: String
    let Content: AttributedString
    let CreatedAt: Date
    let UpdatedAt: Date
    let IsFavorite: Bool
    let IsSharing: Bool
    
    init(UID: String, NoteID: String, Title: String, Content: AttributedString, CreatedAt: Date, UpdatedAt: Date, IsFavorite: Bool, IsSharing: Bool) {
        self.UID = UID
        self.NoteID = NoteID
        self.Title = Title
        self.Content = Content
        self.CreatedAt = CreatedAt
        self.UpdatedAt = UpdatedAt
        self.IsFavorite = IsFavorite
        self.IsSharing = IsSharing
    }
}

class DatabaseModule: DatabaseModuleProtocol {
    typealias NotesListDatabaseCompletion = (Result<[NoteModel], Error>) -> Void
    typealias DeleteNotesDatabaseCompletion = (Error?) -> Void
    
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = DatabaseModule()
    
    func configure() {
        
    }
}

extension DatabaseModule: NotesListDatabaseProtocol {
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        // FIXME:
        completion(.success([
            NoteModel(UID: "12321", NoteID: "123123", Title: "Test Tittle 1", Content: AttributedString(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsSharing: false),
            NoteModel(UID: "12321", NoteID: "123124", Title: "Test Tittle 2", Content: AttributedString(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsSharing: false),
            NoteModel(UID: "12321", NoteID: "123125", Title: "Test Tittle 3", Content: AttributedString(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsSharing: false)]))
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
}
