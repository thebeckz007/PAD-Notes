//
//  AuthenticationUser.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 25/12/2023.
//

import Foundation
import FirebaseAuth

/// struct AuthenticationUser
struct AuthenticationUser {
    /// user ID as string
    let UID: String
    
    /// Email of user as string
    let email: String
    
    /// Link of photo profile as URL
    let photoURL: URL?
    
    /// Display name of user as string
    let displayName: String?
    
    /// First name of user as string
    let firstName: String?
    
    /// Last name of user as string
    let lastName: String?
    
    /// Date of birth of user as Date
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
    /// Initalize AuthenticationUser from FirUser of Firebase Authentication User
    /// - parameter User: an User as FirUser
    init(FirUser: User) {
        self.init(UID: FirUser.uid, email: FirUser.email ?? "", photoURL: FirUser.photoURL, displayName: FirUser.displayName)
    }
}
