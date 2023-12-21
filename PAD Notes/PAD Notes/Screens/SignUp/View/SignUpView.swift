//
//  SignUpView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewSignUpView
/// List IDview of all views as a const variable
struct constIDViewSignUpView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol SignUpViewprotocol
/// protocol SignUpViewprotocol
protocol SignUpViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct SignUpView
/// Contruct main view
struct SignUpView : View, SignUpViewprotocol {
    @ObservedObject private var viewmodel: SignUpViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            DismissViewButton()
            
            VStack {
                Spacer()
                
                AppLogoImage()
                AppNameText()
                
                VStack {
                    EmailTextField()
                    PasswordTextField()
                }.padding(.vertical, 30)
                
                SignUpButton()
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .alert("Register Failed", isPresented: $viewmodel.isShownError, actions: {
                Button("OK", role: .none) {
                }
            }, message: {
                Text(viewmodel.errMessage)
            })
            //
            .alert("Register Success!", isPresented: $viewmodel.isSignupSuccess, actions: {
                Button("OK", role: .none) {
                    dismiss()
                }
            }, message: {
                Text("Hooray!!!...")
            })
        }
        
        if viewmodel.authStatus == .InProgess {
            viewLoading()
        }
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
    
    private func EmailTextField() -> some View {
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
    }
    
    private func PasswordTextField() -> some View {
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
    }
    
    private func SignUpButton() -> some View {
        Button {
            viewmodel.signUp()
        } label: {
            ZStack {
                Text("Register")
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
    }
    
    private func DismissViewButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark.circle").tint(.blue)
        }.padding(EdgeInsets(top: 10, leading: 30, bottom: 0, trailing: 0))
    }
}

#Preview {
    let model = SignUpModel(authModule: AuthenticationModule.sharedInstance)
    let viewmodel = SignUpViewModel(model: model)
    return SignUpView(viewmodel: viewmodel)
}
