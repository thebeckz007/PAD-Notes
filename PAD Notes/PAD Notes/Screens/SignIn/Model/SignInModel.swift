//
//  SignInModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignInModelprotocol
/// protocol SignInModelprotocol
protocol SignInModelprotocol: BaseModelProtocol {
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

// MARK: struct SignInModel
/// struct SignInModel
struct SignInModel: SignInModelprotocol {
    private let authModule: AuthenticationModuleProtocol
    
    init(authModule: AuthenticationModuleProtocol) {
        self.authModule = authModule
    }
    
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1000000000000), execute: {
            self.authModule.SignIn(email: email, password: password, completion: completion)
        })
    }
    
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        self.AuthenticateWithSocial(type, completion: completion)
    }
}
