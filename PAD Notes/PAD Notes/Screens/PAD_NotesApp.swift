//
//  PAD_NotesApp.swift
//  PAD Notes
//
//  Created by Phan Anh Duy on 21/12/2023.
//

import SwiftUI
import FIRDatabaseWrapper

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // setup Authentication Module
        AuthenticationModule.sharedInstance.Configure()
        
        // setup Database Module
        NoteDatabaseModule.sharedInstance.configure(firDBRef: FIRDatabaseWrapper.sharedInstance)
        
        return true
    }
}

@main
struct PAD_NotesApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomePageBuilder.setupHomePage()
        }
    }
}
