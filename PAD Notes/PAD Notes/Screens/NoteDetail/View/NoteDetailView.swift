//
//  NoteDetailView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewNoteDetailView
/// List IDview of all views as a const variable
struct constIDViewNoteDetailView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol NoteDetailViewprotocol
/// protocol NoteDetailViewprotocol
protocol NoteDetailViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct NoteDetailView
/// Contruct main view
struct NoteDetailView : View, NoteDetailViewprotocol {
    @ObservedObject var viewmodel: NoteDetailViewModel
    
    init(viewmodel: NoteDetailViewModel) {
        self.viewmodel = viewmodel
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(content: {
                    titleNoteTextField()
                    Divider()
                        .padding()
                        .foregroundColor(.mint)
                    contentNoteTextView()
                    Spacer()
                })
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.topBarTrailing) {
                        if let _ = viewmodel.note {
                            updateNoteButton()
                        } else {
                            addNewNoteButton()
                        }
                    }
                }
            }
            .alert("Failed", isPresented: $viewmodel.isShownError, actions: {
                Button("OK", role: .none) {
                }
            }, message: {
                Text(viewmodel.errMessage)
            })
            //
            .alert("Success!", isPresented: $viewmodel.isShownSuccess, actions: {
                Button("OK", role: .none) {
                    viewmodel.refreshDataIfNeed()
                    dismiss()
                }
            }, message: {
                Text("Hooray!!!...")
            })
            
            if self.viewmodel.isShownLoading {
                ViewLoading()
            }
        }
    }
    
    //
    private func addNewNoteButton() -> some View {
        VStack {
            Button {
                self.viewmodel.addNewNote()
            } label: {
                ZStack {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.mint)
                        
                }
            }
            .disabled(viewmodel.disableAddNewNoteButton)
            .opacity(viewmodel.disableAddNewNoteButton ? 0.5 : 1.0)
        }
    }
    
    private func updateNoteButton() -> some View {
        VStack {
            Button {
                self.viewmodel.updateNote()
            } label: {
                ZStack {
                    Text("Update")
                        .font(.headline)
                        .foregroundColor(.mint)
                }
            }
            .disabled(viewmodel.disableUpdateNoteButton)
            .opacity(viewmodel.disableUpdateNoteButton ? 0.5 : 1.0)
        }
    }
    
    private func titleNoteTextField() -> some View {
        VStack(content: {
            TextField("Enter Title note", text: $viewmodel.titleNote)
                .font(.title2)
                .foregroundColor(.mint)
                .padding()
        })
    }
    
    private func contentNoteTextView() -> some View {
        VStack {
            TextField("Content note", text: $viewmodel.contentNote, prompt: Text("Enter content note"), axis: .vertical)
                .font(.callout)
                .padding()
        }
    }
}

#Preview {
    let model = NoteDetailModel(dbModule: NoteDatabaseModule.sharedInstance)
    let viewmodel = NoteDetailViewModel(model: model, note: NoteModel(UID: "12321", NoteID: "123123", Title: "Test Tittle", Content: "The first version of SwiftUI, released along with iOS 13, didn't come with a native UI component for a multiline text field. To support multiline input, developers had to wrap a UITextView from the UIKit framework and make it available to their SwiftUI project by adopting the UIViewRepresentable protocol. In iOS 14, Apple introduced a new component called TextEditor for the SwiftUI framework. This TextEditor enables developers to display and edit multiline text in your apps. Additionally, in iOS 16, Apple further improved the built-in TextField to support multiline input. In this chapter, we will demonstrate how to utilize both TextEditor and TextField for handling multiline input in your SwiftUI apps.", CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false), authUser: AuthenticationUser(UID: "123", email: "Thebeckz007@gmail.com", photoURL: URL(string: "https://developer.apple.com/assets/elements/icons/swiftui/swiftui-128x128_2x.png"), displayName: "Duy Phan"))
    return NoteDetailView(viewmodel: viewmodel)
}
