import Foundation

struct Appointment: Codable {
    var id: Int
    var doctorName: String
    var specialty: String
    var clinic: String
    var address: String
    var phone: String
    var date: String // npr. "2026-10-20 09:30"
    var status: String // "booked", "cancelled", "done"
    var note: String?
    var room: String?
}

struct AppointmentsResponse: Codable {
    var appointments: [Appointment]
}

struct Doctor: Codable {
    var name: String
    var specialty: String
    var freeSlots: [String]
}
