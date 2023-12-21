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
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesDatabaseCompletion)
}

// MARK: struct NotesListModel
/// struct NotesListModel
struct NotesListModel: NotesListModelprotocol {
    private let dbModule: NotesDatabaseProtocol
    
    init(dbModule: NotesDatabaseProtocol) {
        self.dbModule = dbModule
    }
    
    func getAllNotesByUser(_ userId: String, completion: @escaping DatabaseModule.NotesDatabaseCompletion) {
        self.dbModule.getAllNotesByUser(userId, completion: completion)
    }
}
