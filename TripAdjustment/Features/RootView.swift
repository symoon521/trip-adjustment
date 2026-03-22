import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            NavigationStack {
                ExpenseListView()
            }
            .tabItem {
                Label("Expenses", systemImage: "list.bullet.rectangle")
            }

            NavigationStack {
                TripManagementView()
            }
            .tabItem {
                Label("Trips", systemImage: "suitcase")
            }
        }
    }
}

