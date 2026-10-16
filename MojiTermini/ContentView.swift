import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = AppointmentsViewModel()
    @State var selectedTab = 0
    @State var showBooking = false
    @State var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                // header
                HStack {
                    VStack(alignment: .leading) {
                        Text("Pozdrav, " + UserDefaults.standard.string(forKey: "patientName")!)
                            .font(.system(size: 22, weight: .bold))
                        Text("OIB: " + UserDefaults.standard.string(forKey: "patientOIB")!)
                            .font(.system(size: 13))
                            .foregroundColor(Constants.gray)
                    }
                    Spacer()
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            // TODO profil
                        }
                }
                .padding()

                Picker("", selection: $selectedTab) {
                    Text("Nadolazeći").tag(0)
                    Text("Prošli").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                TextField("Traži", text: $searchText)
                    .padding(8)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .cornerRadius(8)
                    .padding(.horizontal)

                List {
                    ForEach(filteredAppointments(), id: \.doctorName) { appointment in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appointment.doctorName)
                                    .font(.system(size: 17, weight: .semibold))
                                Text(appointment.specialty)
                                    .font(.system(size: 14))
                                    .foregroundColor(Constants.gray)
                                Text(formatDate(appointment.date))
                                    .font(.system(size: 14))
                                    .foregroundColor(Constants.blue)
                            }
                            Spacer()
                            if appointment.status == "cancelled" {
                                Text("Otkazano")
                                    .font(.system(size: 12))
                                    .foregroundColor(.red)
                            }
                            Image(systemName: "phone.fill")
                                .foregroundColor(Constants.blue)
                                .onTapGesture {
                                    UIApplication.shared.open(URL(string: "tel:" + appointment.phone)!)
                                }
                        }
                        .padding(.vertical, 6)
                        .onTapGesture {
                            // TODO: otvoriti detalje termina
                            print("tapped \(appointment.id)")
                        }
                        .swipeActions {
                            Button("Otkaži") {
                                let index = filteredAppointments().firstIndex(where: { $0.id == appointment.id })!
                                viewModel.cancel(index: index)
                            }
                            .tint(.red)
                        }
                    }
                }
                .listStyle(PlainListStyle())

                Button(action: {
                    showBooking = true
                }) {
                    Text("Naruči novi termin")
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(Constants.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom)
            }
            .navigationBarTitle("Moji termini")
            .background(Color.white)
            .onAppear {
                viewModel.loadAppointments()
            }
            .sheet(isPresented: $showBooking) {
                BookingView()
            }
        }
    }

    func filteredAppointments() -> [Appointment] {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let today = formatter.string(from: Date())

        var result = [Appointment]()
        for a in viewModel.appointments {
            if selectedTab == 0 {
                if a.date > today {
                    result.append(a)
                }
            } else {
                if a.date < today {
                    result.append(a)
                }
            }
        }
        if searchText != "" {
            result = result.filter { $0.doctorName.contains(searchText) }
        }
        return result
    }

    func formatDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: string)!

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd.MM.yyyy. 'u' HH:mm"
        return formatter2.string(from: date)
    }
}

#Preview {
    ContentView()
}
