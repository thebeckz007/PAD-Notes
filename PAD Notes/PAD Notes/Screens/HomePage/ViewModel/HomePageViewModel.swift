//
//  HomePageViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol HomePageViewModelprotocol
/// protocol HomePageViewModelprotocol
protocol HomePageViewModelprotocol: BaseViewModelProtocol {
    func GetCurrentUser()
    func startListeningUserStatus()
    func navigateNotesListView() -> NotesListView
    func navigateSignInView() -> SignInView
}

// MARK: class HomePageViewModel
/// class HomePageViewModel
class HomePageViewModel: ObservableObject, HomePageViewModelprotocol {
    private let model: HomePageModelprotocol
    @Published var user: AuthenticationUser?
    
    init(model: HomePageModelprotocol) {
        self.model = model
    }
    
    func GetCurrentUser() {
        self.user = self.model.GetCurrentUser()
    }
    
    func startListeningUserStatus() {
        self.model.listenUserStatus { user in
            self.user = user
        }
    }
    
    func navigateNotesListView() -> NotesListView {
        return NotesListBuilder.setupNotesListView(user: self.user!)
    }
    
    func navigateUserProfile() -> UserProfileView {
        return UserProfileBuilder.setupUserProfile(authUser: self.user!)
    }
    
    func navigateSignInView() -> SignInView {
        return SignInBuilder.setupSignin()
    }
}
