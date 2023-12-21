//
//  SignInBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignInBuilderprotocol
/// protcol SignInBuilderprotocol
protocol SignInBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class SignInBuilder
/// class SignInBuilder
class SignInBuilder: SignInBuilderprotocol {
     class func setupSignin() -> SignInView {
         let model = SignInModel(authModule: AuthenticationModule.sharedInstance)
         let viewmodel = SignInViewModel(signinModel: model)
         let view = SignInView(viewmodel: viewmodel)
         
         return view
     }
}
