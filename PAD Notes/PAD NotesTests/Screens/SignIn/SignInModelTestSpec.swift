//
//  SignInModelTestSpec.swift
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



class SignInModelTestSpec: QuickSpec {
    override class func spec() {
        var model: SignInModel?
        
        beforeEach {
            let authModule = MockAuthenticationModule()
            model = SignInModel(authModule: authModule)
        }
        
        describe("Test SignInModelprotocol") {
            context("User sign in with Email/ passwrod ") {
                it("Sign in success") {
                    model?.SignIn(email: ExpectedData.signInUser.email, password: ExpectedData.signInUserPassword, completion: { result in
                        expect {
                            switch result {
                            case .success(let authUser):
                                return .succeeded
                            case .failure(let error):
                                return .failed(reason: "Get an error with \(error.localizedDescription)")
                            }
                        }.to(succeed())
                    })
                }
                
                it("Sign in fail by wrong password") {
                    model?.SignIn(email: ExpectedData.signInUser.email, password: ExpectedData.signInUserWrongPassword, completion: { result in
                        expect {
                            switch result {
                            case .success(let authUser):
                                return .failed(reason: "The result was wrong expected data")
                            case .failure(let error):
                                return .succeeded
                            }
                        }.to(succeed())
                    })
                }
            }
            
            context("Social user authenticate") {
                it("Google sign in") {
                    model?.AuthenticateWithSocial(AuthenticationSupportingSocialType.Google, completion: { result in
                        expect {
                            switch result {
                            case .success(let authUser):
                                if authUser?.UID == ExpectedData.GoogleSignIn.UID {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            case .failure(let error):
                                return .failed(reason: "Get an error with \(error.localizedDescription)")
                            }
                        }.to(succeed())
                    })
                }
                
                it("Facebook sign in") {
                    model?.AuthenticateWithSocial(AuthenticationSupportingSocialType.Facebook, completion: { result in
                        expect {
                            switch result {
                            case .success(let authUser):
                                if authUser?.UID == ExpectedData.FacebookSignIn.UID {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            case .failure(let error):
                                return .failed(reason: "Get an error with \(error.localizedDescription)")
                            }
                        }.to(succeed())
                    })
                }
                
                it("Apple sign in") {
                    model?.AuthenticateWithSocial(AuthenticationSupportingSocialType.Apple, completion: { result in
                        expect {
                            switch result {
                            case .success(let authUser):
                                if authUser?.UID == ExpectedData.AppleSignIn.UID {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            case .failure(let error):
                                return .failed(reason: "Get an error with \(error.localizedDescription)")
                            }
                        }.to(succeed())
                    })
                }
            }
        }
    }
}

private class MockAuthenticationModule: AuthenticationEmailProtocol, AuthenticationSocialProtocol {
    func SignUp(email: String, password: String, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
        // Nothings
    }
    
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
                
