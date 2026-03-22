import SwiftUI

@main
struct TripAdjustmentApp: App {
    @StateObject private var appState = AppState.sample()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
        }
    }
}

