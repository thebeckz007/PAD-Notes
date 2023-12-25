//
//  SignUpModelTestSpec.swift
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
    static let signUpUser = AuthenticationUser(UID: "SignUpUser", email: "SignUpUser@gmail.com")
    static let signUpUserPassword = "SignUpUser"
    static let signUpExistingUserEmail = "Existing User"
}



class SignUpModelTestSpec: QuickSpec {
    override class func spec() {
        var model: SignUpModel?
        
        beforeEach {
            let authModule = MockAuthenticationModule()
            model = SignUpModel(authModule: authModule)
        }
        
        describe("Test SignInModelprotocol") {
            context("User sign up with Email/ passwrod ") {
                it("Sign up success") {
                    model?.SignUp(email: ExpectedData.signUpUser.email, password: ExpectedData.signUpUserPassword, completion: { result in
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
                
                it("Sign up fail by email already exist") {
                    model?.SignUp(email: ExpectedData.signUpExistingUserEmail, password: ExpectedData.signUpUserPassword, completion: { result in
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
        }
    }
}

private class MockAuthenticationModule: AuthenticationEmailProtocol {
    func SignUp(email: String, password: String, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
        if password == ExpectedData.signUpUserPassword
            && email == ExpectedData.signUpUser.email {
            completion(.success(ExpectedData.signUpUser))
        } else {
            completion(.failure(MockError.ExistingAccount))
        }
    }
    
    func SignIn(email: String, password: String, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
        // Nothings
    }
}

private enum MockError: Error {
    /// Not existing account/ User error
    case ExistingAccount
    
    /// Unkonw error
    case Unknown

    var localizedDescription: String {
      switch self {
      case .ExistingAccount:
        return "Account already exist"
      case .Unknown:
          return "Unknown Error"
      }
    }
}
