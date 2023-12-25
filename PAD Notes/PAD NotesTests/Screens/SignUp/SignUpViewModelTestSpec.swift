//
//  SignUpViewModelTestSpec.swift
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



class SignUpViewModelTestSpec: QuickSpec {
    override class func spec() {
        var viewmodel: SignUpViewModel?
        
        beforeEach {
            let model = MockSignUpModel()
            viewmodel = SignUpViewModel(model: model)
        }
        
        describe("Test SignUpViewModelprotocol") {
            context("User sign up with Email/ passwrod ") {
                it("Sign up success") {
                    viewmodel?.email = ExpectedData.signUpUser.email
                    viewmodel?.password = ExpectedData.signUpUserPassword
                    viewmodel?.signUp()
                    
                    expect(viewmodel?.authUser?.UID).toEventually(equal(ExpectedData.signUpUser.UID))
                }
                
                it("Sign up fail by email already exist") {
                    viewmodel?.email = ExpectedData.signUpExistingUserEmail
                    viewmodel?.password = ExpectedData.signUpUserPassword
                    viewmodel?.signUp()
                    
                    expect(viewmodel?.errMessage).toNotEventually(beNil())
                }
            }
        }
    }
}

private struct MockSignUpModel: SignUpModelprotocol {
    func SignUp(email: String, password: String, completion: @escaping PAD_Notes.AuthenticationModule.AuthenticationModuleCompletion) {
        if password == ExpectedData.signUpUserPassword
            && email == ExpectedData.signUpUser.email {
            completion(.success(ExpectedData.signUpUser))
        } else {
            completion(.failure(MockError.ExistingAccount))
        }
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
