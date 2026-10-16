import Foundation
import SwiftUI

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: self)!
    }
}

func daysUntil(_ dateString: String) -> Int {
    let date = dateString.toDate()
    let diff = date.timeIntervalSince(Date())
    return Int(diff / 86400)
}

extension Color {
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
}
