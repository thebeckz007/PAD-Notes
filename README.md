# PAD-Notes
A notes application for iOS, iPadOS. This project is the showcase of MVVM architecture, following SOLID principles, using Firebase Authentication, Firebase Realtime Database and SwiftUI, SwiftCombine, etc.

<img src="Screenshots/SignInscreen.png" width="300"/> <img src="Screenshots/Notelists.png" width="300"/> <img src="Screenshots/Notelists_Swipedeleting.png" width="300"/> <img src="Screenshots/NoteLists_Swipesharing.png" width="300"/>

# Features 
- User: -> spend time: ~10hrs
    + Create with email/ password
    + Login with email/ password
    + Update display name
    
- Note: -> spend time: ~9hrs
    + Create a note
    + Update/ delete a note
    + Listing notes by user
    + Listing shared notes of all User
    + Swipe to delete a note
    + Swipe to share/ unshare a note
    
- Unit-Test: 
    + NoteDatabaseModule: -> spend time: ~4hrs
        + Test NotesListDatabaseProtocol
        + Test NotesDetailDatabaseProtocol 
    + SignIn screen: -> spend time: ~1h
        + Test SignInModel
        + Test SignInViewModel
    + SignUp screen: -> spend time: 30mins
        + Test SignUpModel
        + Test SignUpViewModel

# Backlogs
- User:
    + Sign in with Google, Apple, Facebook
    + Update User Photo
    + Input Day of birth

- Note:
    + Support Attributring to display custom font
    + Support Hyperlink
    + Support Image inline
    + Support Comment
    + Group notes by directory
    
- Sharing:
    + Share note with a grant level: 
        + Read only
        + Read and write
        + None
        
- Others:
    + Retouch UI 
    
# Techniques
- SwiftUI: to develop User Interfaces
- SwiftCombine: to bind data
- Grand central Dispatch (GCD): to multithread 
- MVVM architecture: develop application
- Firebase Authentication: to authenticate user by email/ password, Social
- Firebase Realtime database: to store note data
- Quick, Nimble framework: to write UnitTest
- Follow SOLID principles

## Environment
- XCode 15.0 ++
- iOS 17 ++

## How to run
To run/ compile the app, we need to install some libraries from Swift Packages Manager:
- Firebase:
    - Authentication
    - Realtime Database
- FIRDatabaseWrapper [Github page](https://github.com/thebeckz007/FIRDatabaseWrapper.git)
 
To run Unit-test, we need to install some libraries from Swift Packages Manager:
- Quick
- Nimble

# Database Schema
>
> 
    Note:
        userId:
            NoteId:
                Title:      // string
                Content:    // string
                createdAt:  // number
                updatedAt:  // number
                isFavorite: // bool
                isShared:   // bool
