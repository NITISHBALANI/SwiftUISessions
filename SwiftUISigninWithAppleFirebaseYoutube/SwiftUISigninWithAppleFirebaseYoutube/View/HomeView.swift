//
//  HomeView.swift
//  SwiftUISigninWithAppleFirebaseYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI
import FirebaseAuth
struct HomeView: View {
    @AppStorage("logStatus") private var logStatus: Bool = false
    var body: some View {
        NavigationStack {
            Button("Logout") {
                try? Auth.auth().signOut()
                logStatus = false
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
