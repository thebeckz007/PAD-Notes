//
//  HomePageBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol HomePageBuilderprotocol
/// protcol HomePageBuilderprotocol
protocol HomePageBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class HomePageBuilder
/// class HomePageBuilder
class HomePageBuilder: HomePageBuilderprotocol {
     class func setupHomePage() -> HomePageView {
         let model = HomePageModel(authModule: AuthenticationModule.sharedInstance)
         let viewmodel = HomePageViewModel(model: model)
         let view = HomePageView(viewmodel: viewmodel)
         
         return view
     }
}
