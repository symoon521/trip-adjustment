import SwiftUI

struct QuickExpenseEntryView: View {
    @Binding var draft: ExpenseDraft
    let baseCurrencyCode: String
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Amount") {
                TextField("Amount", text: $draft.amountText)
                    .keyboardType(.decimalPad)

                TextField("Currency Code", text: $draft.currencyCode)
                    .textInputAutocapitalization(.characters)

                TextField("Exchange Rate to \(baseCurrencyCode)", text: $draft.exchangeRateText)
                    .keyboardType(.decimalPad)
            }

            Section("Details") {
                Picker("Category", selection: $draft.category) {
                    ForEach(ExpenseCategory.allCases) { category in
                        Text(category.title).tag(category)
                    }
                }

                TextField("Merchant", text: $draft.merchantName)
                TextField("Note", text: $draft.note, axis: .vertical)
                DatePicker("Occurred At", selection: $draft.occurredAt)
            }
        }
        .navigationTitle("Quick Expense")
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
        DecimalParser.parse(draft.amountText) != nil && !draft.currencyCode.isEmpty
    }
}

