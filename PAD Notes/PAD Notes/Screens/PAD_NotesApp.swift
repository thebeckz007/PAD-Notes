//
//  PAD_NotesApp.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import SwiftUI

@main
struct PAD_NotesApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageBuilder.setupHomePage()
        }
    }
}
