//
//  HomePageModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol HomePageModelprotocol
/// protocol HomePageModelprotocol
protocol HomePageModelprotocol: BaseModelProtocol {
    func GetCurrentUser() -> AuthenticationUser?
    func listenUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion)
}

// MARK: struct HomePageModel
/// struct HomePageModel
struct HomePageModel: HomePageModelprotocol {
    private let authModule: AuthenticationUserProtocol
    
    init(authModule: AuthenticationUserProtocol) {
        self.authModule = authModule
    }
    
    func GetCurrentUser() -> AuthenticationUser? {
        return self.authModule.GetCurrentUser()
    }
    
    func listenUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion) {
        authModule.listenUserStatus(completion: completion)
    }
}
