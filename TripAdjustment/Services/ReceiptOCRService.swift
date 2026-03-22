import Foundation

struct ReceiptSuggestion {
    var amountText: String
    var currencyCode: String?
    var exchangeRateText: String?
    var category: ExpenseCategory
    var merchantName: String
    var note: String
    var occurredAt: Date
    var receiptImagePath: String?
}

protocol ReceiptOCRService {
    func makeMockSuggestion(defaultCurrencyCode: String) -> ReceiptSuggestion
}

struct MockReceiptOCRService: ReceiptOCRService {
    func makeMockSuggestion(defaultCurrencyCode: String) -> ReceiptSuggestion {
        ReceiptSuggestion(
            amountText: "24.50",
            currencyCode: defaultCurrencyCode,
            exchangeRateText: "1",
            category: .food,
            merchantName: "Sample Bistro",
            note: "OCR draft suggestion",
            occurredAt: Date(),
            receiptImagePath: "receipts/sample-bistro.jpg"
        )
    }
}

