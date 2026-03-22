import SwiftUI

struct TripManagementView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isAddTripPresented = false
    @State private var draft = TripDraft()

    var body: some View {
        List {
            if appState.trips.isEmpty {
                ContentUnavailableView(
                    "No Trips Yet",
                    systemImage: "suitcase",
                    description: Text("Add a trip to start budgeting and recording expenses.")
                )
            } else {
                ForEach(appState.trips) { trip in
                    Button {
                        appState.selectTrip(id: trip.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(trip.name)
                                    .font(.headline)
                                Text("\(trip.budgetAmount.currencyString(code: trip.baseCurrencyCode)) budget")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if appState.selectedTripID == trip.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteTrips)
            }
        }
        .navigationTitle("Trips")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    draft = TripDraft()
                    isAddTripPresented = true
                } label: {
                    Label("Add Trip", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddTripPresented) {
            NavigationStack {
                TripFormView(draft: $draft) {
                    if appState.addTrip(from: draft) {
                        isAddTripPresented = false
                    }
                }
            }
        }
    }

    private func deleteTrips(at offsets: IndexSet) {
        let ids = offsets.map { appState.trips[$0].id }
        appState.deleteTrips(ids: Set(ids))
    }
}

private struct TripFormView: View {
    @Binding var draft: TripDraft
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Trip") {
                TextField("Trip Name", text: $draft.name)
                TextField("Base Currency Code", text: $draft.baseCurrencyCode)
                    .textInputAutocapitalization(.characters)
                TextField("Budget", text: $draft.budgetText)
                    .keyboardType(.decimalPad)
            }

            Section("Dates") {
                DatePicker("Start", selection: $draft.startDate, displayedComponents: .date)
                DatePicker("End", selection: $draft.endDate, displayedComponents: .date)
            }
        }
        .navigationTitle("New Trip")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave()
                }
                .disabled(!isDraftValid)
            }
        }
    }

    private var isDraftValid: Bool {
        !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (DecimalParser.parse(draft.budgetText) ?? 0) > 0 &&
        !draft.baseCurrencyCode.isEmpty
    }
}

