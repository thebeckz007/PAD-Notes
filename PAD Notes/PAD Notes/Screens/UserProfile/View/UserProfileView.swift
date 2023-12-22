//
//  UserProfileView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewUserPofileView
/// List IDview of all views as a const variable
struct constIDViewUserPofileView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol UserProfileViewprotocol
/// protocol UserProfileViewprotocol
protocol UserProfileViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct UserProfileView
/// Contruct main view
struct UserProfileView : View, UserProfileViewprotocol {
    @ObservedObject private var viewmodel: UserProfileViewModel
    
    init(viewmodel: UserProfileViewModel) {
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, content: {
                UserPhotoImage()
                
                //
                VStack {
                    EmailText()
                    DisplayNameTextField()
                }
                Spacer()
                
                VStack {
                    updateUserButton()
                    logoutButton()
                }
                
                Spacer()
            })
            .alert("update Failed", isPresented: $viewmodel.isShownError, actions: {
                Button("OK", role: .none) {
                }
            }, message: {
                Text(viewmodel.errMessage)
            })
            //
            .alert("Update Success!", isPresented: $viewmodel.isShownSuccess, actions: {
                Button("OK", role: .none) {
                }
            }, message: {
                Text("Hooray!!!...")
            })
            
            if viewmodel.isShownLoading {
                ViewLoading()
            }
        }
    }
    
    private func UserPhotoImage() -> some View {
        Button(action: {
            // FIXME:
        }, label: {
            AsyncImage(url: viewmodel.authUser.photoURL) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 150)
            } placeholder: {
                ZStack {
                    Image("Notes_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                    ProgressView().progressViewStyle(.circular)
                }
            }
        })
    }
    
    private func EmailText() -> some View {
        HStack (alignment: .top, content: {
            VStack (alignment: .leading) {
                Text("Email")
                    .font(.title)
                    .foregroundStyle(.mint)
                Text(viewmodel.authUser.email)
                    .font(.callout)
                    .foregroundStyle(.mint)
            }
            .padding(.leading)
            
            Spacer()
        })
        .padding()
    }
    
    private func DisplayNameTextField() -> some View {
        HStack (alignment: .top, content: {
            VStack (alignment: .leading) {
                Text("Display name")
                    .font(.title)
                    .foregroundStyle(.mint)
                TextField("Enter display name here...", text: $viewmodel.newDisplayName)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    .padding()
                    .background(Color(UIColor.secondarySystemFill))
                    .cornerRadius(10)
            }
            .padding(.leading)
            
            Spacer(minLength: 30)
        })
        .padding()
    }
    
    private func logoutButton() -> some View {
        VStack {
            Spacer(minLength: 30)
            Button {
                viewmodel.signOut()
            } label: {
                ZStack {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    
    private func updateUserButton() -> some View {
        VStack {
            Spacer(minLength: 30)
            Button {
                viewmodel.updateUser()
            } label: {
                ZStack {
                    Text("Update")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.mint)
                        .cornerRadius(10)
                }
            }
            .disabled(viewmodel.disableUpdateButton)
            .opacity(viewmodel.disableUpdateButton ? 0.5 : 1.0)
        }
        .padding()
    }
}

#Preview {
    let model = UserProfileModel(authModule: AuthenticationModule.sharedInstance)
    let viewmodel = UserProfileViewModel(model: model, authUser: AuthenticationUser(UID: "123", email: "Thebeckz007@gmail.com", photoURL: URL(string: "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-128x128_2x.png"), displayName: "Duy Phan"))
    return UserProfileView(viewmodel: viewmodel)
}
