//
//  ContentView.swift
//  SwiftUIMovableGrids
//
//  Created by NextDay Sotware Solution on 03/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var colors: [Color] = [
        .gray,
        .green,
        .yellow,
        .orange,
        .purple,
        .cyan,
        .mint,
        .brown,
        .red,
        .indigo
    ]
    @State private var draggingItem: Color?
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                let columns = Array(repeating: GridItem(spacing: 10), count: 3)
                LazyVGrid(columns: columns, spacing: 10, content: {
                    ForEach(colors, id: \.self) { color in
                        GeometryReader { proxy in
                            let size = proxy.size
                            RoundedRectangle(cornerRadius: 8)
                                .fill(color.gradient)
                                .draggable(color) {
                                    ///Custom Preview View
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 1, height: 1)
                                        .onAppear(perform: {
                                            draggingItem = color
                                        })
                                }
                                .dropDestination(for: Color.self) { items, location in
                                    draggingItem = nil
                                    return false
                                } isTargeted: { status in
                                    if let draggingItem, status, draggingItem != color {
                                        ///Moving color from source to destination
                                       if let sourceIndex = colors.firstIndex(of: draggingItem),
                                          let destinationIndex = colors.firstIndex(of: color) {
                                           let sourceItem = colors.remove(at: sourceIndex)
                                           withAnimation {
                                               colors.insert(sourceItem, at: destinationIndex)
                                           }
                                       }
                                    }
                                }

                        }
                        .frame(height: 100)
                    }
                    
                    .onMove(perform: { indices, newOffset in
                        
                    })
                })
                .padding()
                
            }
            .navigationTitle("Movable Grid")
        }
        
    }
}

#Preview {
    ContentView()
}
