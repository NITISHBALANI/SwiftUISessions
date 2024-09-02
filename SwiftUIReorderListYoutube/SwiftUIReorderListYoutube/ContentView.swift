//
//  ContentView.swift
//  SwiftUIReorderListYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var mockData: [Episode] = MockData.episodes
    var body: some View {
        NavigationStack {
            List {
                ForEach(mockData) { episode in
                    HStack(alignment: .top, spacing: 12){
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 75, height: 75)
                            .foregroundStyle(episode.color)
                        VStack(alignment: .leading, content: {
                            Text(episode.title)
                                .font(.headline)
                            Text("Here is the short description for the latest episode.")
                        })
                    }
                }
                .onMove(perform: { indices, newOffset in
                    mockData.move(fromOffsets: indices, toOffset: newOffset)
                    var counter = 0
                    for data in mockData {
                        data.listOrder = counter
                        counter += 1
                        print(data.title, "list order \(data.listOrder)")
                    }
                    print("---------------Completed--------------------")
                })
            }
            .listStyle(.automatic)
        }
        .navigationTitle("Episodes")
//        .onChange(of: mockData) { oldValue, newValue in
//            var counter = 0
//            for data in newValue {
//                data.listOrder = counter
//                counter += 1
//                print(data.title, "list order \(data.listOrder)")
//            }
//            print("---------------Completed--------------------")
//        }
    }
}

#Preview {
    NavigationStack { ContentView() }
}
class Episode: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var color: Color
    var listOrder: Int
    
    init(title: String, color: Color, listOrder: Int) {
        self.title = title
        self.color = color
        self.listOrder = listOrder
    }
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
}
struct MockData {
    static var episodes = [
        Episode(title: "Pink Episode", color: .pink, listOrder: 0),
        Episode(title: "Purple Episode", color: .purple, listOrder: 1),
        Episode(title: "Blue Episode", color: .blue, listOrder: 2),
        Episode(title: "Green Episode", color: .green, listOrder: 3),
        Episode(title: "Yellow Episode", color: .yellow, listOrder: 4),
        Episode(title: "Gray Episode", color: .gray, listOrder: 5),
        Episode(title: "Red Episode", color: .red, listOrder: 6),
        Episode(title: "Brown Episode", color: .brown, listOrder: 7),
        Episode(title: "Teal Episode", color: .teal, listOrder: 8),
        Episode(title: "Cyan Episode", color: .cyan, listOrder: 9),
        Episode(title: "Indigo Episode", color: .indigo, listOrder: 10)
    ]
}
