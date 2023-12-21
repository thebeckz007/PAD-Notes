//
//  AuthenticationModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

protocol AuthenticationModuleProtocol {
    func Configure()
    func GetCurrentUser() -> AuthenticationUser
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

enum AuthenticationSupportingSocialType: UInt {
    case Google = 1
    case Facebook = 2
    case Apple = 3
    
    var name: String {
        switch self {
        case .Google:
            "Google"
        case .Facebook:
            "Facebook"
        case .Apple:
            "Apple"
        }
    }
}

struct AuthenticationUser {
    let UID: String
    let email: String
    let photoURL: String?
    let displayName: String?
    let firstName: String?
    let lastName: String?
    let DateOfBirth: Date?
    
    init(UID: String, email: String, photoURL: String? = nil, displayName: String? = nil, firstName: String? = nil, lastName: String? = nil, DateOfBirth: Date? = nil) {
        self.UID = UID
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.DateOfBirth = DateOfBirth
    }
}

class AuthenticationModule: AuthenticationModuleProtocol {
    //
    typealias AuthenticationModuleCompletion = (Result<AuthenticationUser?, Error>) -> Void
    
    //
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = AuthenticationModule()
    
    func Configure() {
        // config FIrebase Authentication
        
        // config Google sign in
        
        // config Facebook sign in
    
        // config Apple sign in
    }
    
    func GetCurrentUser() -> AuthenticationUser {
        // FIXME:
        return AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com", photoURL: "string")
    }
    
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModuleCompletion) {
        // FIXME:
        completion(.success(AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com")))
    }
    
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModuleCompletion) {
        // FIXME:
        completion(.success(AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com", photoURL: "string")))
    }
    
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        // FIXME:
        completion(.success(AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com", photoURL: "string")))
    }
}

