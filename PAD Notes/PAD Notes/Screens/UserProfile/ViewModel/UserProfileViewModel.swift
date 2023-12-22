//
//  UserProfileViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol UserProfileViewModelprotocol
/// protocol UserProfileViewModelprotocol
protocol UserProfileViewModelprotocol: BaseViewModelProtocol {
    func signOut()
    func updateUser()
}

// MARK: class UserProfileViewModel
/// class UserProfileViewModel
class UserProfileViewModel: ObservableObject, UserProfileViewModelprotocol {
    private let model: UserProfileModelprotocol
    
    @Published var authUser: AuthenticationUser
    @Published var newPassword: String?
    @Published var newPhotoURL: URL?
    @Published var newDisplayName: String = ""
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    @Published var isShownSuccess: Bool = false
    @Published var isShownLoading: Bool = false
    
    var disableUpdateButton: Bool {
        ((self.newDisplayName.isEmpty || self.newDisplayName.lowercased() ==  self.authUser.displayName?.lowercased())
                  && self.newPhotoURL == nil)
    }
    
    init(model: UserProfileModelprotocol, authUser: AuthenticationUser) {
        self.model = model
        self.authUser = authUser
        self.newDisplayName = authUser.displayName ?? ""
    }
    
    func signOut() {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.signOut { [weak self] error in
            self?.isShownLoading = false
            
            if let err = error {
                self?.errMessage = err.localizedDescription
                self?.isShownError = true
            }
        }
    }
    
    func updateUser() {
        if let pw = newPassword {
            self.updatePassword(pw)
        }
        
        if let photoURL = newPhotoURL {
            self.updatePhotoURL(photoURL)
        }
        
        if !newDisplayName.isEmpty && newDisplayName.lowercased() !=  authUser.displayName?.lowercased() {
            self.updateDisplayName(newDisplayName)
        }
    }
    
    // MARK: Private functions
    private func resetState() {
        self.errMessage = ""
        self.isShownError = false
        self.isShownSuccess = false
        self.isShownLoading = false
    }
    
    private func updatePassword(_ password: String) {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.updatePassword(password) { [weak self] error in
            self?.isShownLoading = false
            
            if let err = error {
                self?.errMessage = err.localizedDescription
                self?.isShownError = true
            } else {
                self?.isShownSuccess = true
            }
        }
    }
    
    private func updatePhotoURL(_ photoURL: URL) {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.updateUser(displayName: nil, photoURL: photoURL) { [weak self] result in
            self?.handleAuthenticationResult(result: result)
        }
    }
    
    private func updateDisplayName(_ displayname: String) {
        self.resetState()
        
        self.isShownLoading = true
        
        self.model.updateUser(displayName: displayname, photoURL: nil) { [weak self] result in
            self?.handleAuthenticationResult(result: result)
        }
    }
    
    fileprivate func handleAuthenticationResult(result: Result<AuthenticationUser?, Error>) {
        DispatchQueue.main.async {
            self.isShownLoading = false
            
            switch result {
            case .success(let authUser):
                self.authUser = authUser!
                self.isShownSuccess = true
            case .failure(let error):
                self.errMessage = error.localizedDescription
                self.isShownError = true
            }
        }
    }
}
