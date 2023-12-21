//
//  NotesListViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol NotesListViewModelprotocol
/// protocol NotesListViewModelprotocol
protocol NotesListViewModelprotocol: BaseViewModelProtocol {
    func getAllNotesByUser()
}

// MARK: class NotesListViewModel
/// class NotesListViewModel
class NotesListViewModel: ObservableObject, NotesListViewModelprotocol {
    private let model: NotesListModelprotocol
    private let user: AuthenticationUser
    
    @Published var arrNotes: [NoteModel] = [NoteModel]()
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    
    init(model: NotesListModelprotocol, user: AuthenticationUser) {
        self.model = model
        self.user = user
    }
    
    func getAllNotesByUser() {
        self.model.getAllNotesByUser(self.user.UID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let arrNotes):
                    self.arrNotes = arrNotes
                case .failure(let error):
                    self.errMessage = error.localizedDescription
                    self.isShownError = true
                }
            }
        }
    }
    
    // MARK: private functions
    
}
