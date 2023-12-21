//
//  DatabaseModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

protocol DatabaseModuleProtocol {
    
}

protocol NotesDatabaseProtocol {
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesDatabaseCompletion)
}

struct NoteModel {
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

class DatabaseModule: DatabaseModuleProtocol, NotesDatabaseProtocol {
    typealias NotesDatabaseCompletion = (Result<[NoteModel], Error>) -> Void
    
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = DatabaseModule()
    
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesDatabaseCompletion) {
        // FIXME:
        completion(.success([NoteModel(UID: "123", NoteID: "312", Title: "Test Tittle", Content: AttributedString("content"), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: false, IsSharing: true)]))
    }
}
