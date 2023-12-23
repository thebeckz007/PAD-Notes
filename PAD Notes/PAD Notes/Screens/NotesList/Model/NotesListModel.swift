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
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion)
    func deleteNotes(notes:[NoteModel], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion)
    func getAllSharedNotesExcluedUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion)
}

// MARK: struct NotesListModel
/// struct NotesListModel
struct NotesListModel: NotesListModelprotocol {
    private let dbModule: NotesListDatabaseProtocol
    
    init(dbModule: NotesListDatabaseProtocol) {
        self.dbModule = dbModule
    }
    
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        self.dbModule.queryNotesByUser(userId, completion: completion)
    }
    
    func deleteNotes(notes:[NoteModel], completion: @escaping DatabaseModule.DeleteNotesDatabaseCompletion) {
        self .dbModule.deleteNotes(notes: notes, completion: completion)
    }
    
    func getAllSharedNotesExcluedUser(_ userId: String, completion: @escaping DatabaseModule.NotesListDatabaseCompletion) {
        self.dbModule.querySharedNotesExcludeUser(userId, completion: completion)
    }
}
