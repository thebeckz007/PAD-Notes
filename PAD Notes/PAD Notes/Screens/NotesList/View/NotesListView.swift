//
//  NotesListView.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import SwiftUI

// MARK: struct constIDViewNotesListView
/// List IDview of all views as a const variable
struct constIDViewNotesListView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol NotesListViewprotocol
/// protocol NotesListViewprotocol
protocol NotesListViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct NotesListView
/// Contruct main view
struct NotesListView : View, NotesListViewprotocol {
    @ObservedObject private var viewmodel: NotesListViewModel
    
    init(viewmodel: NotesListViewModel) {
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationStack {
                    List {
                        ForEach(viewmodel.arrNotes, id:\.NoteID) { Note in
                            NavigationLink(destination: viewmodel.navigateNoteDetail(Note)) {
                                VStack(alignment: .leading) {
                                    Text(Note.Title).font(.system(size: 22, weight: .regular))
                                    Text("Updated at \(Note.UpdatedAt.formatted(date: Date.FormatStyle.DateStyle.omitted, time: Date.FormatStyle.TimeStyle.shortened))").foregroundStyle(.gray)
                                }.frame(maxHeight: 200)
                            }
                        }.onDelete(perform: self.viewmodel.deleteData(at:))
                    }
                    .navigationTitle("Notes")
                }
            }
            
            if self.viewmodel.isShownLoading {
                ViewLoading()
            }
        }.onAppear {
            viewmodel.getAllNotesByUser()
        }
    }
    
    private func UserProfileButton() -> some View {
        VStack {
            AsyncImage(url: viewmodel.authUser.photoURL) { image in  
                image.resizable()
                    .scaledToFit()
                    .frame(width: 150)
            } placeholder: {
                ZStack {
                    Image("Notes_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                }
            }
        }
    }
    
    private func SearchingNotesTextField() -> some View {
        VStack {
            // contruct Textfield for iOS 17++
            if #available(iOS 17.0, *) {
                TextField("Service name", text: $viewmodel.searchingNotes)
                    .font(.body)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2662717301)))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .onChange(of: viewmodel.searchingNotes) {
                        viewmodel.searchNotes()
                    }
            } else {
                // Contruct Textfield for iOS 14 to < 17
                TextField("Service name", text: $viewmodel.searchingNotes)
                    .font(.body)
                    .padding()
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.2662717301)))
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                    .onChange(of: viewmodel.searchingNotes, perform: { value in
                        viewmodel.searchingNotes = value
                        viewmodel.searchNotes()
                    })
            }
        }
    }
    
    private func ComposeNoteButton() -> some View {
        VStack {
            Button {
                self.viewmodel.newComposeNote()
            } label: {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .bold()
                    .accentColor(.mint)
            }
        }
    }
}

#Preview {
    let model = NotesListModel(dbModule: DatabaseModule.sharedInstance)
    let viewmodel = NotesListViewModel(model: model, authUser: AuthenticationUser(UID: "123", email: "123123"))
    return NotesListView(viewmodel: viewmodel)
}
