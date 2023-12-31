//
//  NoteDatabaseModuleTestSpec.swift
//  PAD NotesTests
//
//  Created by Phan Anh Duy on 24/12/2023.
//

import Quick
import Nimble
import Foundation
import FIRDatabaseWrapper

@testable import PAD_Notes

// Fake expected data
private struct ExpectedData {
    static let User = AuthenticationUser(UID: "UkPNaejHqNa00gFrmUyCEfWS4Ow2", email: "123123")
    static let Note1 = NoteModel(UID: User.UID, NoteID: "1111111", Title: "Test Tittle 1", Content: "tes content 1", CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false)
    static let Note2 = NoteModel(UID: User.UID, NoteID: "1111112", Title: "Test Tittle 2", Content: "tes content 2", CreatedAt: Date(), UpdatedAt: Date(), IsFavorite: true, IsShared: false)
    static let QueryNotes = [Note1, Note2]
    static let updatedTitle = "Updated Title"
    static let updatedContent = "Updated Content"
}



class NoteDatabaseModuleTestSpec: QuickSpec {
    override class func spec() {
        var dbModule: NoteDatabaseModule?

        beforeEach {
            let firDBModule = MockFIRDatabaseWrapper()
            dbModule = NoteDatabaseModule.sharedInstance
            dbModule?.configure(firDBRef: firDBModule)
        }
        
        describe("Test NotesListDatabaseProtocol") {
            context("Query notes by user") {
                it("existing user") {
                    dbModule?.queryNotesByUser(ExpectedData.User.UID, completion: { result in
                        switch result {
                        case .success(let arrNotes):
                            //
                            expect(arrNotes.count).to(equal(ExpectedData.QueryNotes.count))
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
                
                it("not existing user") {
                    dbModule?.queryNotesByUser("Not existing UserID", completion: { result in
                        switch result {
                        case .success(let arrNotes):
                            //
                            expect(arrNotes.count).to(equal(0))
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Query shared notes excludes user") {
                it("Query shared notes excludes user") {
                    dbModule?.querySharedNotesExcludeUser(ExpectedData.User.UID, completion: { result in
                        switch result {
                        case .success(let arrNotes):
                            //
                            expect(arrNotes.count).to(equal(0))
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Delete notes") {
                it("Delete notes") {
                    let expectedDeletedNotes = ExpectedData.QueryNotes
                    dbModule?.deleteNotes(notes: expectedDeletedNotes, completion: { arrNotes in
                        expect(arrNotes.count).to(equal(expectedDeletedNotes.count))
                    })
                }
            }
            
            context("share/ unshare notes") {
                it("share notes") {
                    let expectedSharedNotes = ExpectedData.QueryNotes
                    let isShared = true
                    dbModule?.sharedNotes(expectedSharedNotes, isShared: isShared, completion: { result in
                        let notes = result.filter{$0.IsShared == isShared}
                        expect(notes.count).to(equal(expectedSharedNotes.count))
                    })
                }
                
                it("unshare notes") {
                    let expectedUnsharedNotes = ExpectedData.QueryNotes
                    let isShared = false
                    dbModule?.sharedNotes(expectedUnsharedNotes, isShared: isShared, completion: { result in
                        let notes = result.filter{$0.IsShared == isShared}
                        expect(notes.count).to(equal(expectedUnsharedNotes.count))
                    })
                }
            }
        }
        
        describe("Test NoteDetailDatabaseProtocol") {
            context("Add a note") {
                it("Add a note") {
                    dbModule?.addNewNote(userID: ExpectedData.User.UID, title: ExpectedData.Note1.Title, content: ExpectedData.Note1.Content, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = ExpectedData.Note1
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Update a note") {
                it("Update title of note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.Title = ExpectedData.updatedTitle
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
                
                it("Update content of note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.Content = ExpectedData.updatedContent
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Favorite a note") {
                it("Favorite a note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.IsFavorite = true
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content 
                                    && note.IsFavorite == expectedNote.IsFavorite {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
                
                it("Unfavorite a note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.IsFavorite = false
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content
                                    && note.IsFavorite == expectedNote.IsFavorite {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Share a note") {
                it("Share a note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.IsShared = true
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content
                                    && note.IsShared == expectedNote.IsShared {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
                
                it("Unshare a note") {
                    var updatedNote = ExpectedData.Note1
                    updatedNote.IsShared = false
                    dbModule?.updateNote(updatedNote, completion: { result in
                        switch result {
                        case .success(let note):
                            let expectedNote = updatedNote
                            expect {
                                if note.UID == expectedNote.UID
                                    && note.Title == expectedNote.Title
                                    && note.Content == expectedNote.Content
                                    && note.IsShared == expectedNote.IsShared {
                                    return .succeeded
                                } else {
                                    return .failed(reason: "The result was wrong expected data")
                                }
                            }.to(succeed())
                        case .failure(let error):
                            //
                            fail("Get an error with \(error.localizedDescription)")
                        }
                    })
                }
            }
            
            context("Delete a note") {
                it("Delete a note") {
                    dbModule?.deleteNote(ExpectedData.Note1, completion: { error in
                        expect {
                            if let err = error {
                                return .failed(reason: "We got an error\(err.localizedDescription)")
                            } else {
                                return .succeeded
                            }
                        }.to(succeed())
                    })
                }
            }
        }
    }
}

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabaseInternal

// MARK: mock of RealtimeDatabaseFirebaseModule
fileprivate class MockFIRDatabaseWrapper: FIRDatabaseWrapperProtocol {
    func configure() {
        // Nothings
    }
    
    func set(_ value: Any, at child: String, parentNodes: String..., completion: @escaping (Error?) -> Void) {
        self.set(value, at: child, parentNodes: parentNodes, completion: completion)
    }
    
    func set(_ value: Any, at child: String, parentNodes: [String], completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func get(at child: String, parentNodes: String..., completion: @escaping (Result<FIRDataResult?, Error>) -> Void) {
        self.get(at: child, parentNodes: parentNodes, completion: completion)
    }
    
    func get(at child: String, parentNodes: [String], completion: @escaping (Result<FIRDataResult?, Error>) -> Void) {
        // test case get Notes by existing UserID
        if child == ExpectedData.User.UID {
            completion(.success(FIRDataResult(notes: ExpectedData.QueryNotes)))
        } else {
            // test case get Notes by no existing UserID
            completion(.success(nil))
        }
    }
    
    func delete(at child: String, parentNodes: String..., completion: @escaping (Error?) -> Void) {
        self.delete(at: child, parentNodes: parentNodes, completion: completion)
    }
    
    func delete(at child: String, parentNodes: [String], completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    
}

private struct NoteJsonHelper {
    static func converNotesListToJson(_ arrNotes: [NoteModel]) -> String? {
        var dictData = [String: Any]()
        for note in arrNotes {
            dictData[note.NoteID] = note.dictionaryNote()
        }
        
        return dictData.json
    }
}

extension FIRDataResult {
    init(notes: [NoteModel]) {
        let data = NoteJsonHelper.converNotesListToJson(ExpectedData.QueryNotes)
        self.init(jsonString: data ?? "")
    }
}

extension Dictionary {
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
    }
    
    var json: String? { jsonData?.string }
}

extension Data {
    /// Converting data to a string
    var string: String? { String(data: self, encoding: .utf8) }
}
