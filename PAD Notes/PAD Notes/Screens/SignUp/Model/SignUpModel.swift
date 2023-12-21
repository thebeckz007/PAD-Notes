//
//  SignUpModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignUpModelprotocol
/// protocol SignUpModelprotocol
protocol SignUpModelprotocol: BaseModelProtocol {
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

// MARK: struct SignUpModel
/// struct SignUpModel
struct SignUpModel: SignUpModelprotocol {
    private let authModule: AuthenticationEmailProtocol
    
    init(authModule: AuthenticationEmailProtocol) {
        self.authModule = authModule
    }
    
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        self.authModule.SignUp(email: email, password: password, completion: completion)
    }
}
