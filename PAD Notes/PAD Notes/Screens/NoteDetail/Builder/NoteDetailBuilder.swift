//
//  NoteDetailBuilder.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 22/12/2023.
//
//

import Foundation

// MARK: Protocol NoteDetailBuilderprotocol
/// protcol NoteDetailBuilderprotocol
protocol NoteDetailBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class NoteDetailBuilder
/// class NoteDetailBuilder
class NoteDetailBuilder: NoteDetailBuilderprotocol {
    class func setupDetailNote(_ note: NoteModel?) -> NoteDetailView {
         let model = NoteDetailModel(dbModule: DatabaseModule.sharedInstance)
         let viewmodel = NoteDetailViewModel(model: model, note: note)
         let view = NoteDetailView(viewmodel: viewmodel)
         
         return view
     }
}
