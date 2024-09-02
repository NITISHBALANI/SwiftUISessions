//
//  SwiftUISigninWithAppleFirebaseYoutubeApp.swift
//  SwiftUISigninWithAppleFirebaseYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI
import FirebaseCore

@main
struct SwiftUISigninWithAppleFirebaseYoutubeApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
