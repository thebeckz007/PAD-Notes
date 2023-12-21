//
//  SignUpBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol SignUpBuilderprotocol
/// protcol SignUpBuilderprotocol
protocol SignUpBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class SignUpBuilder
/// class SignUpBuilder
class SignUpBuilder: SignUpBuilderprotocol {
    class func setupSignup() -> SignUpView {
        let model = SignUpModel(authModule: AuthenticationModule.sharedInstance)
        let viewmodel = SignUpViewModel(model: model)
        let view = SignUpView(viewmodel: viewmodel)
        
        return view
    }
}
