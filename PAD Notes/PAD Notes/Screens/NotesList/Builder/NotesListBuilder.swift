//
//  NotesListBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//
//

import Foundation

// MARK: Protocol NotesListBuilderprotocol
/// protcol NotesListBuilderprotocol
protocol NotesListBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class NotesListBuilder
/// class NotesListBuilder
class NotesListBuilder: NotesListBuilderprotocol {
    class func setupNotesListView(user: AuthenticationUser) -> NotesListView {
         let model = NotesListModel(dbModule: DatabaseModule.sharedInstance)
         let viewmodel = NotesListViewModel(model: model, authUser: user)
         let view = NotesListView(viewmodel: viewmodel)
         
         return view
     }
}
