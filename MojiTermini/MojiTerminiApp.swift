import SwiftUI

@main
struct MojiTerminiApp: App {

    init() {
        // spremi token i podatke pacijenta da ih imamo kasnije
        UserDefaults.standard.set(Constants.apiToken, forKey: "token")
        UserDefaults.standard.set("Ivana Horvat", forKey: "patientName")
        UserDefaults.standard.set("12345678903", forKey: "patientOIB")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
