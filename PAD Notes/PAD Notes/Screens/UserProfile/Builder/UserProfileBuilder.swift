//
//  UserProfileBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol UserProfileBuilderprotocol
/// protcol UserProfileBuilderprotocol
protocol UserProfileBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class UserProfileBuilder
/// class UserProfileBuilder
class UserProfileBuilder: UserProfileBuilderprotocol {
    // TODO: Here is place to create a class func to setup View, Model and ViewModel instances  and return View instance
    class func setupUserProfile(authUser: AuthenticationUser) -> UserProfileView {
         let model = UserProfileModel(authModule: AuthenticationModule.sharedInstance)
         let viewmodel = UserProfileViewModel(model: model, authUser: authUser)
         let view = UserProfileView(viewmodel: viewmodel)
         
         return view
     }
}
