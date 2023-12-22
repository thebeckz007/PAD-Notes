//
//  NoteDetailViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol NoteDetailViewModelprotocol
/// protocol NoteDetailViewModelprotocol
protocol NoteDetailViewModelprotocol: BaseViewModelProtocol {
    
}

// MARK: class NoteDetailViewModel
/// class NoteDetailViewModel
class NoteDetailViewModel: ObservableObject, NoteDetailViewModelprotocol {
    private let model: NoteDetailModelprotocol
    @Published var note: NoteModel? // Nil: add new note, not Nil: edit existing note
    
    init(model: NoteDetailModelprotocol, note: NoteModel?) {
        self.model = model
        self.note = note
    }
}
