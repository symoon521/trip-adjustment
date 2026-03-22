import SwiftUI

struct ReceiptDraftReviewView: View {
    @Binding var draft: ExpenseDraft
    let baseCurrencyCode: String
    let onLoadSuggestion: () -> Void
    let onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("OCR Draft") {
                Button("Load Mock Receipt Suggestion") {
                    onLoadSuggestion()
                }

                TextField("Amount", text: $draft.amountText)
                    .keyboardType(.decimalPad)

                TextField("Currency Code", text: $draft.currencyCode)
                    .textInputAutocapitalization(.characters)

                TextField("Exchange Rate to \(baseCurrencyCode)", text: $draft.exchangeRateText)
                    .keyboardType(.decimalPad)
            }

            Section("Review") {
                Picker("Category", selection: $draft.category) {
                    ForEach(ExpenseCategory.allCases) { category in
                        Text(category.title).tag(category)
                    }
                }

                TextField("Merchant", text: $draft.merchantName)
                TextField("Receipt Path", text: $draft.receiptImagePath)
                TextField("Note", text: $draft.note, axis: .vertical)
                DatePicker("Occurred At", selection: $draft.occurredAt)
            }
        }
        .navigationTitle("Receipt Draft")
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

