import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        Group {
            if let trip = appState.selectedTrip {
                List {
                    Section {
                        ForEach(appState.selectedTripExpenses) { expense in
                            ExpenseRowView(expense: expense, baseCurrencyCode: trip.baseCurrencyCode)
                        }
                        .onDelete(perform: deleteExpenses)
                    } header: {
                        Text(trip.name)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Expenses",
                    systemImage: "list.bullet.rectangle",
                    description: Text("Create and select a trip before reviewing expenses.")
                )
            }
        }
        .navigationTitle("Expenses")
    }

    private func deleteExpenses(at offsets: IndexSet) {
        let ids = offsets.map { appState.selectedTripExpenses[$0].id }
        appState.deleteExpenses(ids: Set(ids))
    }
}

private struct ExpenseRowView: View {
    let expense: Expense
    let baseCurrencyCode: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(expense.merchantName.isEmpty ? expense.category.title : expense.merchantName)
                    .font(.headline)
                Spacer()
                Text(expense.convertedAmount.currencyString(code: baseCurrencyCode))
                    .font(.headline)
            }

            Text("\(expense.originalAmount.numberString()) \(expense.originalCurrencyCode) • \(expense.category.title)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(expense.occurredAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.secondary)

            if !expense.note.isEmpty {
                Text(expense.note)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

