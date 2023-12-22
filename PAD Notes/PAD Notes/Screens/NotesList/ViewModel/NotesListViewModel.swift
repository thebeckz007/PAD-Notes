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
    func deleteData(at indexSet: IndexSet)
    func searchNotes()
    func newComposeNote() -> NoteDetailView
    func navigateNoteDetail(_ note: NoteModel) -> NoteDetailView
}

// MARK: class NotesListViewModel
/// class NotesListViewModel
class NotesListViewModel: ObservableObject, NotesListViewModelprotocol {
    private let model: NotesListModelprotocol

    @Published var authUser: AuthenticationUser
    @Published var arrNotes: [NoteModel] = [NoteModel]()
    @Published var searchingNotes: String = ""
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    @Published var isShownLoading: Bool = false
    
    init(model: NotesListModelprotocol, authUser: AuthenticationUser) {
        self.model = model
        self.authUser = authUser
    }
    
    func getAllNotesByUser() {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.getAllNotesByUser(self.authUser.UID) { [weak self] result in
            self?.handleNotesListResult(result: result)
        }
    }
    
    func searchNotes() {
        // FIXME: 
    }
    
    func newComposeNote() -> NoteDetailView {
        return NoteDetailBuilder.setupDetailNote(nil)
    }
    
    func navigateNoteDetail(_ note: NoteModel) -> NoteDetailView {
        return NoteDetailBuilder.setupDetailNote(note)
    }
    
    func deleteData(at indexSet: IndexSet) {
        self.resetState()
        
        self.isShownLoading = true
        var arrDeletingNotes = [NoteModel]()
        indexSet.forEach { index in
            arrDeletingNotes.append(self.arrNotes[index])
        }
        
        self.model.deleteNotes(noteIDs: arrDeletingNotes.map{$0.NoteID}) { [weak self] Error in
            DispatchQueue.main.async {
                if let err = Error {
                    self?.errMessage = err.localizedDescription
                    self?.isShownError = true
                } else {
                    indexSet.forEach { index in
                        self?.arrNotes.remove(at: index)
                    }
                }
            }
        }
    }
    
    // MARK: private functions
    private func resetState() {
        self.errMessage = ""
        self.isShownError = false
        self.isShownLoading = false
    }
    
    fileprivate func handleNotesListResult(result: Result<[NoteModel], Error>) {
        DispatchQueue.main.async {
            self.isShownLoading = false
            
            switch result {
            case .success(let arrNotes):
                self.arrNotes = arrNotes.sorted(by: { $0.UpdatedAt.compare($1.UpdatedAt) == .orderedDescending})
            case .failure(let error):
                self.errMessage = error.localizedDescription
                self.isShownError = true
            }
        }
    }
}
