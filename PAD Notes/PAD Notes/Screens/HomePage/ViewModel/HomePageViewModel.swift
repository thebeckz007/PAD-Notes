//
//  HomePageViewModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol HomePageViewModelprotocol
/// protocol HomePageViewModelprotocol
protocol HomePageViewModelprotocol: BaseViewModelProtocol {
    func GetCurrentUser()
}

// MARK: class HomePageViewModel
/// class HomePageViewModel
class HomePageViewModel: ObservableObject, HomePageViewModelprotocol {
    private let model: HomePageModelprotocol
    @Published var user: AuthenticationUser?
    
    init(model: HomePageModelprotocol) {
        self.model = model
    }
    
    func GetCurrentUser() {
        self.user = self.model.GetCurrentUser()
    }
}
