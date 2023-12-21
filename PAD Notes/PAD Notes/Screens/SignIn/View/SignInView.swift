//
//  SignInView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewSignInView
/// List IDview of all views as a const variable
struct constIDViewSignInView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol SignInViewprotocol
/// protocol SignInViewprotocol
protocol SignInViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct SignInView
/// Contruct main view
struct SignInView : View, SignInViewprotocol {
    @ObservedObject var viewmodel: SignInViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("Notes_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            Text("PAD Notes")
                .font(.title2)
                .bold()
                .padding(.bottom, 20)
            Text("Log In")
                .font(.title)
                .bold()
                .padding(.bottom, 40)

            VStack {
                VStack (alignment: .leading) {
                    Text("Email")
                        .font(.callout)
                    TextField("Enter email here...", text: $viewmodel.email)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(UIColor.secondarySystemFill))
                        .cornerRadius(10)
                }

                VStack (alignment: .leading) {
                    Text("Password")
                        .font(.callout)
                    SecureField("Enter password here...", text: $viewmodel.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                        .padding()
                        .background(Color(UIColor.secondarySystemFill))
                        .cornerRadius(10)
                }
                .padding(.top)
                
            }.padding(.vertical, 30)
            
            Button {
                viewmodel.signin()
            } label: {
                ZStack {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                    if viewmodel.authStatus == .InProgess {
                        ProgressView()
                    }
                }
            }
            .disabled(viewmodel.email.isEmpty || viewmodel.password.isEmpty)

            Spacer()
        }
        .padding(.horizontal, 30)
        .alert("Login Failed", isPresented: $viewmodel.isShownError, actions: {
            Button("OK", role: .none) {
            }
        }, message: {
            Text(viewmodel.errMessage)
        })
    }
}

#Preview {
    let model = SignInModel(authModule: AuthenticationModule.sharedInstance)
    let viewmodel = SignInViewModel(signinModel: model)
    return SignInView(viewmodel: viewmodel)
}
