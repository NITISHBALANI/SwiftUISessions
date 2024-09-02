//
//  ContentView.swift
//  SwiftUISizeClassesYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var body: some View {
        VStack {
            Text(verticalSizeClass == .compact ? "Hello Nitish" : "Hello, world!")
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
