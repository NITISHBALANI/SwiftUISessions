//
//  ContentView.swift
//  SwiftUISigninWithAppleFirebaseYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("logStatus") private var logStatus: Bool = false
    var body: some View {
        if logStatus {
            HomeView()
        }else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
