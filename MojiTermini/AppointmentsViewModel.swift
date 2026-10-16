import Foundation
import SwiftUI

class AppointmentsViewModel: ObservableObject {
    @Published var appointments: [Appointment] = []
    @Published var isLoading = false

    var timer: Timer?
    var onUpdate: (() -> Void)?

    init() {
        // osvjezi termine svakih 30 sekundi
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
            self.loadAppointments()
        }

        onUpdate = {
            print("Appointments updated, count: \(self.appointments.count)")
        }
    }

    func loadAppointments() {
        isLoading = true
        NetworkManager.shared.getAppointments { result in
            self.isLoading = false
            if result != nil {
                self.appointments = result!
            }
            self.onUpdate?()
        }
    }

    func cancel(index: Int) {
        let appointment = appointments[index]
        NetworkManager.shared.cancelAppointment(id: appointment.id) { success in
            if success {
                self.appointments.remove(at: index)
            }
        }
    }
}
