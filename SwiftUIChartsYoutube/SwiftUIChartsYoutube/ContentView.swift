//
//  ContentView.swift
//  SwiftUIChartsYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI
import Charts
struct ContentView: View {
    @State private var downloads: [Download] = appDownloads
    @State private var isAnimated: Bool = false
    @State private var trigger: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Chart {
                    ForEach(downloads) { app in
                        BarMark(
                            x: .value("Month", app.month),
                            y: .value("Downloads", app.isAnimating ? app.value : 0)
                        )
//                        LineMark(
//                            x: .value("Month", app.month),
//                            y: .value("Downloads", app.isAnimating ? app.value : 0)
//                        )
//                        SectorMark(
//                            angle: .value("Downloads", app.isAnimating ? app.value : 0)
//                        )
                        .foregroundStyle(by: .value("Downloads", app.isAnimating ? app.value : 0))
                        .opacity(app.isAnimating ? 1 : 0)
                    }
                }
                .chartYScale(domain: 0...12000)
                .frame(height: 250)
                .padding()
                .background(.background, in: .rect(cornerRadius: 10))
                Spacer()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
            }
            .padding()
            .navigationTitle("Animated Charts")
            .background(.gray.opacity(0.2))
            .onAppear(perform: animateChart)
            .onChange(of: trigger, initial: false) { oldValue, newValue in
                    resetChartAnimation()
                animateChart()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Trigger") {
                        trigger.toggle()
                    }
                }
            }
        }
        
    }
    private func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        $downloads.enumerated().forEach { index, element in
            let delay = Double(index) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth) {
                    element.wrappedValue.isAnimating = true
                }
            }
        }
    }
    private func resetChartAnimation() {
        $downloads.enumerated().forEach { index, element in
            element.wrappedValue.isAnimating = false
        }
        isAnimated = false
    }
}

#Preview {
    ContentView()
}
