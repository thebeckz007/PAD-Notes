//
//  SignInViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignInViewModelprotocol
/// protocol SignInViewModelprotocol
protocol SignInViewModelprotocol: BaseViewModelProtocol {
    func signin()
    func authenticateWithSocial()
}

enum AuthenStatus: UInt {
    case NotStart = 1
    case InProgess = 2
    case Finished = 3
}

// MARK: class SignInViewModel
/// class SignInViewModel
class SignInViewModel: ObservableObject, SignInViewModelprotocol {
    private let signinModel: SignInModelprotocol
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var authSocialType: AuthenticationSupportingSocialType?
    
    @Published var authStatus: AuthenStatus?
    @Published var authUser: AuthenticationUser?
    
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    
    init(signinModel: SignInModelprotocol) {
        self.signinModel = signinModel
    }
    
    //
    func signin() {
        self.resetAuthentication()
        
        signinModel.SignIn(email: email, password: password) {  result in
            self.handleAuthenticationResult(result: result)
        }
    }
    
    
    //
    func authenticateWithSocial() {
        self.resetAuthentication()
        
        signinModel.AuthenticateWithSocial(authSocialType!) { result in
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
