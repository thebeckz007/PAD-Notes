//
//  NotesListModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol NotesListModelprotocol
/// protocol NotesListModelprotocol
protocol NotesListModelprotocol: BaseModelProtocol {
    func getAllNotesByUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion)
    func deleteNotes(notes:[NoteModel], completion: @escaping NoteDatabaseModule.NotesListwWithoutErrorDatabaseCompletion)
    func getAllSharedNotesExcluedUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion)
    func sharedNotes(_ notes: [NoteModel], isShared: Bool, completion: @escaping NoteDatabaseModule.NotesListwWithoutErrorDatabaseCompletion)
}

// MARK: struct NotesListModel
/// struct NotesListModel
struct NotesListModel: NotesListModelprotocol {
    private let dbModule: NotesListDatabaseProtocol
    
    init(dbModule: NotesListDatabaseProtocol) {
        self.dbModule = dbModule
    }
    
    func getAllNotesByUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion) {
        self.dbModule.queryNotesByUser(userId, completion: completion)
    }
    
    func deleteNotes(notes:[NoteModel], completion: @escaping NoteDatabaseModule.NotesListwWithoutErrorDatabaseCompletion) {
        self .dbModule.deleteNotes(notes: notes, completion: completion)
    }
    
    func getAllSharedNotesExcluedUser(_ userId: String, completion: @escaping NoteDatabaseModule.NotesListDatabaseCompletion) {
        self.dbModule.querySharedNotesExcludeUser(userId, completion: completion)
    }
    
    func sharedNotes(_ notes: [NoteModel], isShared: Bool, completion: @escaping NoteDatabaseModule.NotesListwWithoutErrorDatabaseCompletion) {
        self.dbModule.sharedNotes(notes, isShared: isShared, completion: completion)
    }
}
