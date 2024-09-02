//
//  Download.swift
//  SwiftUIChartsYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI

struct Download: Identifiable {
    let id: UUID = .init()
    var date: Date
    var value: Double
    ///Animatable Property
    var isAnimating: Bool = false
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }
}

var appDownloads: [Download] = [
    .init(date: .createDate(1, 3, 2024), value: 2500),
    .init(date: .createDate(1, 4, 2024), value: 3500),
    .init(date: .createDate(1, 5, 2024), value: 9500),
    .init(date: .createDate(1, 6, 2024), value: 1950),
    .init(date: .createDate(1, 7, 2024), value: 5100),
    .init(date: .createDate(1, 8, 2024), value: 2000)
]
extension Date {
   static func createDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        let calender = Calendar.current
        let date = calender.date(from: components) ?? .init()
        return date
    }
}







