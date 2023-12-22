//
//  AuthenticationModule.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import Foundation

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

protocol AuthenticationModuleProtocol {
    func Configure()
}

protocol AuthenticationUserProtocol {
    func GetCurrentUser() -> AuthenticationUser?
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion)
    func delete(completion: @escaping AuthenticationModule.authenticationUserDeleteCompletion)
    func updatePassword(_ password: String, completion: @escaping AuthenticationModule.authenticationUserUpdateCompletion)
    func updateUser(displayName: String?, photoURL: URL?, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func listenUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion)
}

protocol AuthenticationEmailProtocol {
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

protocol AuthenticationSocialProtocol {
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
    let photoURL: URL?
    let displayName: String?
    let firstName: String?
    let lastName: String?
    let DateOfBirth: Date?
    
    init(UID: String, email: String, photoURL: URL? = nil, displayName: String? = nil, firstName: String? = nil, lastName: String? = nil, DateOfBirth: Date? = nil) {
        self.UID = UID
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
        self.firstName = firstName
        self.lastName = lastName
        self.DateOfBirth = DateOfBirth
    }
}

extension AuthenticationUser {
    init(FirUser: User) {
        self.init(UID: FirUser.uid, email: FirUser.email ?? "", photoURL: FirUser.photoURL, displayName: FirUser.displayName)
    }
}

enum AuthenticationModuleError: Error, CustomStringConvertible {
  case NotExistingAccount
  case Unknown

  var description: String {
    switch self {
    case .NotExistingAccount:
      return "Account does not exist"
    case .Unknown:
        return "Unknown Error"
    }
  }
}

//
class AuthenticationModule: AuthenticationModuleProtocol {
    //
    typealias AuthenticationModuleCompletion = (Result<AuthenticationUser?, Error>) -> Void
    typealias AuthenticationUserListenerCompletion = (AuthenticationUser?) -> Void
    typealias authenticationUserUpdateCompletion = (Error?) -> Void
    typealias authenticationUserDeleteCompletion = (Error?) -> Void
    typealias authenticationUserLogOutCompletion = (Error?) -> Void
    
    //
    /// a shared instance of LogsModule as singleton instance
    static let sharedInstance = AuthenticationModule()
    
    func Configure() {
        // config FIrebase Authentication
        FirebaseApp.configure()
        
        // config Google sign in
        
        // config Facebook sign in
        
        // config Apple sign in
    }
    
    // Conform AuthenticationUserProtocol
    func GetCurrentUser() -> AuthenticationUser? {
        if let user = Auth.auth().currentUser {
            return AuthenticationUser(FirUser: user)
        } else {
            return nil
        }
    }
    
    func listenUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion) {
        Auth.auth().addStateDidChangeListener { firAuth, firUser in
            if let user = firUser {
                completion(AuthenticationUser(FirUser: user))
            } else {
                completion(nil)
            }
        }
    }
}

/// Confirm AuthenticationUserProtocol
extension AuthenticationModule: AuthenticationUserProtocol {
    //
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let err as NSError {
            completion(err)
        }
    }
    
    //
    func delete(completion: @escaping AuthenticationModule.authenticationUserDeleteCompletion) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                completion(error)
            }
        } else {
            completion(AuthenticationModuleError.NotExistingAccount)
        }
    }
    
    func updatePassword(_ password: String, completion: @escaping AuthenticationModule.authenticationUserUpdateCompletion) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: password) { error in
                completion(error)
            }
        } else {
            completion(AuthenticationModuleError.NotExistingAccount)
        }
    }
    
    func updateUser(displayName: String?, photoURL: URL?, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = displayName
            changeRequest.photoURL = photoURL
            changeRequest.commitChanges { error in
                if let err = error {
                    completion(.failure(err))
                } else {
                    completion(.success(self.GetCurrentUser()))
                }
            }
        } else {
            completion(.failure(AuthenticationModuleError.NotExistingAccount))
        }
    }
}

// Confirm AuthenticationEmailProtocol
extension AuthenticationModule: AuthenticationEmailProtocol {
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModuleCompletion) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result {
                completion(.success(AuthenticationUser(FirUser: user.user)))
            } else if let err = error {
                completion(.failure(err))
            }
        }
    }
    
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModuleCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result {
                completion(.success(AuthenticationUser(FirUser: user.user)))
            } else if let err = error {
                completion(.failure(err))
            }
        }
    }
}
 
// Confirm AuthenticationSocialProtocol
extension AuthenticationModule: AuthenticationSocialProtocol {
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        // FIXME:
        completion(.success(AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com")))
    }
}


