//
//  NoteModel.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 23/12/2023.
//

import Foundation

struct NoteModel: Codable {
    let UID: String
    let NoteID: String
    var Title: String
    var Content: String
    let CreatedAt: Date
    var UpdatedAt: Date
    var IsFavorite: Bool
    var IsShared: Bool
    
    init(UID: String, NoteID: String, Title: String, Content: String, CreatedAt: Date, UpdatedAt: Date, IsFavorite: Bool = false, IsShared: Bool = true) {
        self.UID = UID
        self.NoteID = NoteID
        self.Title = Title
        self.Content = Content
        self.CreatedAt = CreatedAt
        self.UpdatedAt = UpdatedAt
        self.IsFavorite = IsFavorite
        self.IsShared = IsShared
    }
    
    enum Properties: String, CodingKey {
      case UID, NoteID, Title, Content, CreatedAt, UpdatedAt, IsFavorite, IsShared
    }
}

//
extension NoteModel {
    init(userID: String, title: String, content: String) {
        self.init(UID: userID, NoteID: UUID().uuidString, Title: title, Content: content, CreatedAt: Date(), UpdatedAt: Date())
    }
}

extension NoteModel {
    func dictionaryNote() -> [String: Any] {
        return [Properties.Title.stringValue: self.Title,
                Properties.Content.stringValue: self.Content,
                Properties.CreatedAt.stringValue: self.CreatedAt.timeIntervalSince1970,
                Properties.UpdatedAt.stringValue: self.UpdatedAt.timeIntervalSince1970,
                Properties.IsFavorite.stringValue: self.IsFavorite.description,
                Properties.IsShared.stringValue: self.IsShared.description]
    }
}

extension NoteModel {
    init(userID: String, noteID: String, dictValue: [String: Any]) {
        self.init(UID: userID,
                  NoteID: noteID,
                  Title: dictValue[Properties.Title.stringValue] as! String,
                  Content: dictValue[Properties.Content.stringValue] as! String,
                  CreatedAt: Date(timeIntervalSince1970: dictValue[Properties.CreatedAt.stringValue] as! TimeInterval),
                  UpdatedAt: Date(timeIntervalSince1970: dictValue[Properties.UpdatedAt.stringValue] as! TimeInterval),
                  IsFavorite: (dictValue[Properties.IsFavorite.stringValue] as! NSString).boolValue,
                  IsShared: (dictValue[Properties.IsShared.stringValue] as! NSString).boolValue)
    }
}

extension NoteModel: Equatable {
    static func == (lhs: NoteModel, rhs: NoteModel) -> Bool {
            return lhs.NoteID == rhs.NoteID
        }
}
