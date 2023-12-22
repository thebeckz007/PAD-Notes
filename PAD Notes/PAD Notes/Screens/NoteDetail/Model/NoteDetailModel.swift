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
    
}

// MARK: struct NoteDetailModel
/// struct NoteDetailModel
struct NoteDetailModel: NoteDetailModelprotocol {
    private let dbModule: NoteDatabaseProtocol
    
    init(dbModule: NoteDatabaseProtocol) {
        self.dbModule = dbModule
    }
    
    
}
