//
//  SignUpViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignUpViewModelprotocol
/// protocol SignUpViewModelprotocol
protocol SignUpViewModelprotocol: BaseViewModelProtocol {
    func signUp()
}

// MARK: class SignUpViewModel
/// class SignUpViewModel
class SignUpViewModel: ObservableObject, SignUpViewModelprotocol {
    
    private let model: SignUpModelprotocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var authStatus: AuthenStatus?
    @Published var authUser: AuthenticationUser?
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    
    init(model: SignUpModelprotocol) {
        self.model = model
    }
    
    func signUp() {
        self.resetAuthentication()
        
        model.SignUp(email: email, password: password) {  result in
            self.handleAuthenticationResult(result: result)
        }
    }
    
    fileprivate func handleAuthenticationResult(result: Result<AuthenticationUser?, Error>) {
        DispatchQueue.main.async {
            self.authStatus = .Finished
            switch result {
            case .success(let authUser):
                self.authUser = authUser!
            case .failure(let error):
                self.errMessage = error.localizedDescription
                self.isShownError = true
            }
        }
    }
    
    fileprivate func resetAuthentication() {
        self.authStatus = .NotStart
        self.errMessage = ""
        self.isShownError = false
    }
}
