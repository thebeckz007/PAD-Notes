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
        Text("NotesListView") // TODO: Replace the body
    }
}

#Preview {
    let model = NotesListModel(dbModule: DatabaseModule.sharedInstance)
    let viewmodel = NotesListViewModel(model: model, user: AuthenticationUser(UID: "123", email: "123123"))
    return NotesListView(viewmodel: viewmodel)
}
