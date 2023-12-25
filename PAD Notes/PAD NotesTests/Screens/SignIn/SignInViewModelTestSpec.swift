//
//  SignInViewModelTestSpec.swift
//  PAD NotesTests
//
//  Created by Phan Anh Duy on 25/12/2023.
//

import Quick
import Nimble
import Foundation

@testable import PAD_Notes

// Fake expected data
private struct ExpectedData {
    static let signInUser = AuthenticationUser(UID: "SignInUser", email: "SignInUser@gmail.com")
    static let signInUserPassword = "SignInUser"
    static let signInUserWrongPassword = "Wrong_password"
    
    static let GoogleSignIn = AuthenticationUser(UID: "GoogleSignIn", email: "Google@gmail.com")
    static let FacebookSignIn = AuthenticationUser(UID: "FacebookSignIn", email: "Facebook@gmail.com")
    static let AppleSignIn = AuthenticationUser(UID: "AppleSignIn", email: "Apple@icloud.com")
}



class SignInViewModelTestSpec: QuickSpec {
    override class func spec() {
        var viewmodel: SignInViewModel?
        
        beforeEach {
            let model = MockSignInModel()
            viewmodel = SignInViewModel(signinModel: model)
        }
        
        describe("Test SignInViewModelprotocol") {
            context("User sign in ") {
                it("Sign in success") {
                    viewmodel?.email = ExpectedData.signInUser.email
                    viewmodel?.password = ExpectedData.signInUserPassword
                    viewmodel?.signin()
                    
                    expect(viewmodel?.authUser?.UID).toEventually(equal(ExpectedData.signInUser.UID))
                }
                
                it("Sign in fail by wrong password") {
                    viewmodel?.email = ExpectedData.signInUser.email
                    viewmodel?.password = ExpectedData.signInUserWrongPassword
                    viewmodel?.signin()
                    
                    expect(viewmodel?.errMessage).toNotEventually(beNil())
                }
            }
        }
        
        describe("Test AuthenticationSocialProtocol") {
            context("Social user authenticate") {
                it("Google sign in") {
                    viewmodel?.authenticateWithSocial(AuthenticationSupportingSocialType.Google)
                    expect(viewmodel?.authUser?.UID).toEventually(equal(ExpectedData.GoogleSignIn.UID))
                }
                
                it("Facebook sign in") {
                    viewmodel?.authenticateWithSocial(AuthenticationSupportingSocialType.Facebook)
                    expect(viewmodel?.authUser?.UID).toEventually(equal(ExpectedData.FacebookSignIn.UID))
                }
                
                it("Apple sign in") {
                    viewmodel?.authenticateWithSocial(AuthenticationSupportingSocialType.Apple)
                    expect(viewmodel?.authUser?.UID).toEventually(equal(ExpectedData.AppleSignIn.UID))
                }
            }
        }
        
        describe("Test Navigation") {
            context("Navigate to other screen") {
                it("Navigate to Sign up screen") {
                    let signUpView = viewmodel?.navigateToSignUpScreen()
                    expect(signUpView).toNot(beNil())
                }
            }
        }
    }
}

private struct MockSignInModel: SignInModelprotocol {
    func SignIn(email: String, password: String, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
        if password == ExpectedData.signInUserPassword
            && email == ExpectedData.signInUser.email {
            completion(.success(ExpectedData.signInUser))
        } else {
            completion(.failure(AuthenticationModuleError.NotExistingAccount))
        }
    }
    
    func AuthenticateWithSocial(_ type: PAD_Notes.AuthenticationSupportingSocialType, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
            switch type {
            case .Google:
                completion(.success(ExpectedData.GoogleSignIn))
            case .Facebook:
                completion(.success(ExpectedData.FacebookSignIn))
            case .Apple:
                completion(.success(ExpectedData.AppleSignIn))
            }
    }
}
