//
//  HomePageView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewHomePageView
/// List IDview of all views as a const variable
struct constIDViewHomePageView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol HomePageViewprotocol
/// protocol HomePageViewprotocol
protocol HomePageViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct HomePageView
/// Contruct main view
struct HomePageView : View, HomePageViewprotocol {
    @ObservedObject private var viewmodel: HomePageViewModel
    
    init(viewmodel: HomePageViewModel) {
        self.viewmodel = viewmodel
    }
    
    //
    var body: some View {
        NavigationView(content: {
            if let user = viewmodel.user {
                NotesListBuilder.setupNotesListView(user: user)
            } else {
                SignInBuilder.setupSignin()
            }
        })
        .onAppear(perform: {
            viewmodel.GetCurrentUser()
        })
    }
    
    private func AppLogoImage() -> some View {
        Image("Notes_logo")
            .resizable()
            .scaledToFit()
            .frame(width: 150)
    }
    
    private func AppNameText() -> some View {
        Text("PAD Notes")
            .font(.title)
            .bold()
            .padding(.bottom, 20)
    }
}

#Preview {
    let model = HomePageModel(authModule: AuthenticationModule.sharedInstance)
    let viewmodel = HomePageViewModel(model: model)
    return HomePageView(viewmodel: viewmodel)
}
