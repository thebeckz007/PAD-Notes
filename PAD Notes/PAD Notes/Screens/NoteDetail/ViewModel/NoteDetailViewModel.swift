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
    func addNewNote()
    func updateNote()
}

// MARK: class NoteDetailViewModel
/// class NoteDetailViewModel
class NoteDetailViewModel: ObservableObject, NoteDetailViewModelprotocol {
    private let model: NoteDetailModelprotocol
    private let authUser: AuthenticationUser
    @Published var note: NoteModel? // Nil: add new note, not Nil: edit existing note
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    @Published var isShownSuccess: Bool = false
    @Published var isShownLoading: Bool = false
    
    @Published var titleNote: String = ""
    @Published var contentNote: String = ""
    
    var disableUpdateNoteButton: Bool {
        ((self.titleNote.isEmpty || self.titleNote.lowercased() ==  self.note!.Title.lowercased())
         && (self.contentNote.isEmpty || self.contentNote.lowercased() ==  self.note!.Content.lowercased()))
    }
    
    var disableAddNewNoteButton: Bool {
        (self.titleNote.isEmpty || self.contentNote.isEmpty)
    }
    
    init(model: NoteDetailModelprotocol, note: NoteModel?, authUser: AuthenticationUser) {
        self.model = model
        self.authUser = authUser
        self.note = note
        if let noteTemp = note {
            self.titleNote = noteTemp.Title
            self.contentNote = noteTemp.Content
        }
    }
    
    func addNewNote() {
        self.resetState()
        self.isShownLoading = true
        
        self.model.addNewNote(userID: self.authUser.UID, title: self.titleNote, content: self.contentNote) { [weak self] result in
            self?.handleNoteResult(result: result)
        }
    }
    
    func updateNote() {
        // clone to updated Note model
        if var updatedNote = self.note {
            self.resetState()
            self.isShownLoading = true
            
            updatedNote.Title = self.titleNote
            updatedNote.Content = self.contentNote
            
            self.model.updateNote(updatedNote) { [weak self] result in
                self?.handleNoteResult(result: result)
            }
        }
    }
    
    // MARK: Private functions
    private func resetState() {
        self.errMessage = ""
        self.isShownError = false
        self.isShownSuccess = false
        self.isShownLoading = false
    }
    
    fileprivate func handleNoteResult(result: Result<NoteModel, Error>) {
        DispatchQueue.main.async {
            self.isShownLoading = false
            
            switch result {
            case .success(let note):
                self.note = note
                self.isShownSuccess = true
            case .failure(let error):
                self.errMessage = error.localizedDescription
                self.isShownError = true
            }
        }
    }
}
