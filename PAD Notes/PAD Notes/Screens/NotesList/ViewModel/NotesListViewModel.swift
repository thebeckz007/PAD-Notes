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
    func getAllNotes()
    func getAllNotesByUser()
    func getAllSharedNotesExcludUser()
    func deleteData(at indexSet: IndexSet)
    func searchNotes()
    func newComposeNote() -> NoteDetailView
    func navigateNoteDetail(_ note: NoteModel) -> NoteDetailView
    func navigateUserProfile() -> UserProfileView
}

// MARK: class NotesListViewModel
/// class NotesListViewModel
class NotesListViewModel: ObservableObject, NotesListViewModelprotocol {
    private let model: NotesListModelprotocol

    @Published var authUser: AuthenticationUser
    @Published var arrNotes: [NoteModel] = [NoteModel]()
    @Published var arrSharedNotes: [NoteModel] = [NoteModel]()
    @Published var searchingNotes: String = ""
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    @Published var isShownLoading: Bool = false
    
    @Published var shouldNavigateComposeNote = false
    
    init(model: NotesListModelprotocol, authUser: AuthenticationUser) {
        self.model = model
        self.authUser = authUser
    }
    
    func getAllNotes() {
        self.getAllNotesByUser()
        self.getAllSharedNotesExcludUser()
    }
    
    func getAllNotesByUser() {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.getAllNotesByUser(self.authUser.UID) { [weak self] result in
            self?.handleNotesListResult(result: result)
        }
    }
    
    func getAllSharedNotesExcludUser() {
        self.model.getAllSharedNotesExcluedUser(self.authUser.UID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let arrNotes):
                    self?.arrSharedNotes = arrNotes.sorted(by: { $0.UpdatedAt.compare($1.UpdatedAt) == .orderedDescending})
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchNotes() {
        // FIXME: 
    }
    
    func newComposeNote() -> NoteDetailView {
        return NoteDetailBuilder.setupDetailNote(nil, authUser: self.authUser)
    }
    
    func navigateNoteDetail(_ note: NoteModel) -> NoteDetailView {
        return NoteDetailBuilder.setupDetailNote(note, authUser: self.authUser)
    }
    
    func deleteData(at indexSet: IndexSet) {
        self.resetState()
        
        self.isShownLoading = true
        
        var arrDeletingNotes = [NoteModel]()
        indexSet.forEach { index in
            arrDeletingNotes.append(self.arrNotes[index])
        }
        
        self.model.deleteNotes(notes: arrDeletingNotes) { [weak self] removedNotes in
            DispatchQueue.main.async {
                self?.isShownLoading = false
                self?.arrNotes = self?.arrNotes.filter{!removedNotes.contains($0)} ?? [NoteModel]()
            }
        }
    }
    
    func navigateUserProfile() -> UserProfileView {
        return UserProfileBuilder.setupUserProfile(authUser: self.authUser)
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
