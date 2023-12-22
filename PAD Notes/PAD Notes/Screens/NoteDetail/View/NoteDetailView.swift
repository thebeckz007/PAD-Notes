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
    
    var body: some View {
        Text("NoteDetailView") // TODO: Replace the body
    }
}

#Preview {
    let model = NoteDetailModel(dbModule: DatabaseModule.sharedInstance)
    let viewmodel = NoteDetailViewModel(model: model, note: NoteModel(UID: "12321", NoteID: "123123", Title: "Test Tittle", Content: AttributedString(String("213212312")), CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsSharing: false))
    return NoteDetailView(viewmodel: viewmodel)
}
