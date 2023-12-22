//
//  UserProfileModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol UserProfileModelprotocol
/// protocol UserProfileModelprotocol
protocol UserProfileModelprotocol: BaseModelProtocol {
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion)
    func delete(completion: @escaping AuthenticationModule.authenticationUserDeleteCompletion)
    func updatePassword(_ password: String, completion: @escaping AuthenticationModule.authenticationUserUpdateCompletion)
    func updateUser(displayName: String?, photoURL: URL?, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

// MARK: struct UserProfileModel
/// struct UserProfileModel
struct UserProfileModel: UserProfileModelprotocol {
    private let authModule: AuthenticationUserProtocol
    
    init(authModule: AuthenticationUserProtocol) {
        self.authModule = authModule
    }
    
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion) {
        self.authModule.signOut(completion: completion)
    }
    
    func delete(completion: @escaping AuthenticationModule.authenticationUserDeleteCompletion) {
        self.authModule.delete(completion: completion)
    }
    
    func updatePassword(_ password: String, completion: @escaping AuthenticationModule.authenticationUserUpdateCompletion) {
        self.authModule.updatePassword(password, completion: completion)
    }
    
    func updateUser(displayName: String?, photoURL: URL?, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        self.authModule.updateUser(displayName: displayName, photoURL: photoURL, completion: completion)
    }
}
