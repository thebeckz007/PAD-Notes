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

// MARK: protocol AuthenticationModuleProtocol
/// protocol AuthenticationModuleProtocol
protocol AuthenticationModuleProtocol {
    /// Configure something
    func Configure()
}

// MARK: protocol AuthenticationUserProtocol
/// protocol AuthenticationUserProtocol
/// List of functions for user
protocol AuthenticationUserProtocol {
    /// get current user
    /// - returns: the current user
    func GetCurrentUser() -> AuthenticationUser?
    
    /// Perform signing user out
    /// - parameter completion: the call back result with format (Error?). It means the signing user out is success if we don't have any error.
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion)
    
    /// Perform deleting user
    /// - parameter completion: the call back result with format (Error?). It means the deleting user is success if we don't have any error.
    func delete(completion: @escaping AuthenticationModule.authenticationUserDeleteCompletion)
    
    /// Perform updating password of user
    /// - parameter password: the new password what will be updated
    /// - parameter completion: the call back result with format (Error?). It means the updating password of user  is success if we don't have any error.
    func updatePassword(_ password: String, completion: @escaping AuthenticationModule.authenticationUserUpdateCompletion)
    
    /// Perform updating display name of user
    /// - parameter displayName: the new display name os user
    /// - parameter photoURL: the link of photo profile of user
    /// - parameter completion: the call back result with format (Result<AuthenticationUser?, Error>). It means the updating new information of user  is success if we have a updated user and no errors.
    func updateUser(displayName: String?, photoURL: URL?, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    
    /// Start listening of the the user status changing
    /// - parameter completion: the call back result with format (AuthenticationUser?) . If AuthenticationUser is nil -> user just logged out, and if AuthenticationUser is not nil -> user just logged in.
    func startListeningUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion)
    
    /// Stop listening of the the user status changing
    func stopListeningUserStatus()
}

// MARK: protocol AuthenticationEmailProtocol
/// protocol AuthenticationEmailProtocol
/// List of functions for user using email/ password
protocol AuthenticationEmailProtocol {
    func SignUp(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
    func SignIn(email: String, password: String, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

// MARK: protocol AuthenticationSocialProtocol
/// protocol AuthenticationSocialProtocol
/// List of functions for user using social
protocol AuthenticationSocialProtocol {
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion)
}

/// Enum AuthenticationSupportingSocialType
/// list of supporting social so far
enum AuthenticationSupportingSocialType: UInt {
    /// Google sign in
    case Google = 1
    
    /// Facebook sign in
    case Facebook = 2
    
    /// Apple sign in
    case Apple = 3
    
    /// The name as string type
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

/// Error handling for AuthenticationModule
enum AuthenticationModuleError: Error {
    /// Not existing account/ User error
    case NotExistingAccount
    
    /// Unkonw error
    case Unknown

    var localizedDescription: String {
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
    /// a shared instance of AuthenticationModule as singleton instance
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
    
    /// Instance of AuthStateDidChangeListenerHandle
    private var listenerUserStatus: AuthStateDidChangeListenerHandle?
    
    /// The list of AuthenticationModule.AuthenticationUserListenerCompletion
    private var arrCompletionListenerUserStatus = [AuthenticationModule.AuthenticationUserListenerCompletion]()
    
    func startListeningUserStatus(completion: @escaping AuthenticationModule.AuthenticationUserListenerCompletion) {
        // add completion to arrCompletionListenerUserStatus
        self.arrCompletionListenerUserStatus.append(completion)
        
        // check listenerUserStatus was created or not
        guard self.listenerUserStatus == nil else {
            return
        }
        
        self.listenerUserStatus = Auth.auth().addStateDidChangeListener {[weak self] firAuth, firUser in
            if let guardSelf = self {
                if let user = firUser {
                    for completionListener in guardSelf.arrCompletionListenerUserStatus {
                        completionListener(AuthenticationUser(FirUser: user))
                    }
                } else {
                    for completionListener in guardSelf.arrCompletionListenerUserStatus {
                        completionListener(nil)
                    }
                }
            }
        }
    }
    
    func stopListeningUserStatus() {
        if let listener = self.listenerUserStatus {
            Auth.auth().removeStateDidChangeListener(listener)
            
            // Reset and remove listener instance and list of completions
            self.listenerUserStatus = nil
            self.arrCompletionListenerUserStatus.removeAll()
        }
    }
}

/// Conformming AuthenticationUserProtocol
extension AuthenticationModule: AuthenticationUserProtocol {
    func signOut(completion: @escaping AuthenticationModule.authenticationUserLogOutCompletion) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let err as NSError {
            completion(err)
        }
    }
    
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

// Conformming AuthenticationEmailProtocol
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
 
// Conformming AuthenticationSocialProtocol
extension AuthenticationModule: AuthenticationSocialProtocol {
    func AuthenticateWithSocial(_ type: AuthenticationSupportingSocialType, completion: @escaping AuthenticationModule.AuthenticationModuleCompletion) {
        // FIXME: Support it later
        completion(.success(AuthenticationUser(UID: "17235712683", email: "thebeckz007@gmail.com")))
    }
}
