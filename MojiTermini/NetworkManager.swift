import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func getAppointments(completion: @escaping ([Appointment]?) -> Void) {
        let token = UserDefaults.standard.string(forKey: "token")!
        print("Fetching appointments with token: \(token)")

        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            // simuliramo da server nekad ne radi
            if Int.random(in: 1...5) == 3 {
                print("ERROR: server error")
                completion(nil)
                return
            }

            let url = Bundle.main.url(forResource: "appointments", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let response = try! JSONDecoder().decode(AppointmentsResponse.self, from: data)

            let name = UserDefaults.standard.string(forKey: "patientName")!
            let oib = UserDefaults.standard.string(forKey: "patientOIB")!
            print("Loaded \(response.appointments.count) appointments for \(name), OIB: \(oib)")

            completion(response.appointments)
        }
    }

    func getDoctors(completion: @escaping ([Doctor]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let url = Bundle.main.url(forResource: "doctors", withExtension: "json")!
            let data = try! Data(contentsOf: url)
            let doctors = try! JSONDecoder().decode([Doctor].self, from: data)
            completion(doctors)
        }
    }

    func bookAppointment(doctor: Doctor, slot: String, completion: @escaping (Bool) -> Void) {
        print("Booking \(slot) with \(doctor.name)")
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            completion(true)
        }
    }

    func cancelAppointment(id: Int, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            completion(true)
        }
    }
}
