//
//  NoteDetailModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol NoteDetailModelprotocol
/// protocol NoteDetailModelprotocol
protocol NoteDetailModelprotocol: BaseModelProtocol {
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion)
}

// MARK: struct NoteDetailModel
/// struct NoteDetailModel
struct NoteDetailModel: NoteDetailModelprotocol {
    private let dbModule: NoteDatabaseProtocol
    
    init(dbModule: NoteDatabaseProtocol) {
        self.dbModule = dbModule
    }
    
    func addNewNote(userID: String, title: String, content: String, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        self.dbModule.addNewNote(userID: userID, title: title, content: content, completion: completion)
    }
    
    func updateNote(_ note: NoteModel, completion: @escaping DatabaseModule.AddUpdateNoteDatabaseCompletion) {
        self.dbModule.updateNote(note, completion: completion)
    }
}
