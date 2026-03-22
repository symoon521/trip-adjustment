import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isQuickEntryPresented = false
    @State private var isReceiptPresented = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let summary = appState.selectedTripSummary {
                    SummaryCardView(summary: summary)

                    actionButtons

                    if appState.selectedTripExpenses.isEmpty {
                        ContentUnavailableView(
                            "No Expenses Yet",
                            systemImage: "tray",
                            description: Text("Capture the first expense for this trip.")
                        )
                    } else {
                        recentExpenses
                    }
                } else {
                    ContentUnavailableView(
                        "No Trip Selected",
                        systemImage: "suitcase",
                        description: Text("Create a trip first so budget tracking and receipt capture have a context.")
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Trip Overview")
        .sheet(isPresented: $isQuickEntryPresented) {
            NavigationStack {
                QuickExpenseEntryView(
                    draft: Binding(
                        get: { appState.quickEntryDraft },
                        set: { appState.quickEntryDraft = $0 }
                    ),
                    baseCurrencyCode: appState.selectedTrip?.baseCurrencyCode ?? "USD",
                    onSave: {
                        if appState.saveQuickEntry() {
                            isQuickEntryPresented = false
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $isReceiptPresented, onDismiss: {
            appState.receiptDraft = .blank(defaultCurrencyCode: appState.selectedTrip?.baseCurrencyCode ?? "USD")
        }) {
            NavigationStack {
                ReceiptDraftReviewView(
                    draft: Binding(
                        get: { appState.receiptDraft },
                        set: { appState.receiptDraft = $0 }
                    ),
                    baseCurrencyCode: appState.selectedTrip?.baseCurrencyCode ?? "USD",
                    onLoadSuggestion: {
                        appState.prepareReceiptDraft()
                    },
                    onSave: {
                        if appState.saveReceiptDraft() {
                            isReceiptPresented = false
                        }
                    }
                )
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                isQuickEntryPresented = true
            } label: {
                Label("Quick Add", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button {
                appState.prepareReceiptDraft()
                isReceiptPresented = true
            } label: {
                Label("Receipt Draft", systemImage: "camera.viewfinder")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }

    private var recentExpenses: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Expenses")
                .font(.headline)

            ForEach(appState.selectedTripExpenses.prefix(5)) { expense in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(expense.merchantName.isEmpty ? expense.category.title : expense.merchantName)
                            .font(.subheadline.weight(.semibold))
                        Spacer()
                        Text(expense.convertedAmount.currencyString(code: appState.selectedTrip?.baseCurrencyCode ?? "USD"))
                            .font(.subheadline.weight(.semibold))
                    }

                    Text("\(expense.originalAmount.numberString()) \(expense.originalCurrencyCode) • \(expense.category.title)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

