import SwiftUI

struct BookingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var doctors: [Doctor] = []
    @State var selectedDoctor: Int = 0
    @State var selectedSlot: String = ""
    @State var note = ""
    @State var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Liječnik")) {
                    Picker("Liječnik", selection: $selectedDoctor) {
                        ForEach(0..<doctors.count, id: \.self) { i in
                            Text(doctors[i].name + " - " + doctors[i].specialty)
                        }
                    }
                }

                Section(header: Text("Termin")) {
                    // TODO: prikazati slobodne termine odabranog liječnika
                    Text("Odaberi termin")
                        .foregroundColor(Constants.gray)
                }

                Section(header: Text("Napomena")) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                }

                Button("Rezerviraj") {
                    NetworkManager.shared.bookAppointment(doctor: doctors[selectedDoctor], slot: selectedSlot) { success in
                        showAlert = true
                    }
                }
            }
            .navigationBarTitle("Novi termin")
            .navigationBarItems(trailing: Button("Zatvori") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                NetworkManager.shared.getDoctors { result in
                    doctors = result
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Uspjeh"), message: Text("Termin je rezerviran!"), dismissButton: .default(Text("OK")))
            }
        }
    }
}
