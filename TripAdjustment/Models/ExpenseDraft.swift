import Foundation

struct ExpenseDraft {
    var amountText: String = ""
    var currencyCode: String = "USD"
    var exchangeRateText: String = "1"
    var category: ExpenseCategory = .food
    var merchantName: String = ""
    var note: String = ""
    var occurredAt: Date = Date()
    var receiptImagePath: String = ""
    var ocrDraftStatus: OCRDraftStatus = .none

    static func blank(defaultCurrencyCode: String) -> ExpenseDraft {
        ExpenseDraft(currencyCode: defaultCurrencyCode, exchangeRateText: "1")
    }

    static func fromSuggestion(_ suggestion: ReceiptSuggestion, defaultCurrencyCode: String) -> ExpenseDraft {
        ExpenseDraft(
            amountText: suggestion.amountText,
            currencyCode: suggestion.currencyCode ?? defaultCurrencyCode,
            exchangeRateText: suggestion.exchangeRateText ?? "1",
            category: suggestion.category,
            merchantName: suggestion.merchantName,
            note: suggestion.note,
            occurredAt: suggestion.occurredAt,
            receiptImagePath: suggestion.receiptImagePath ?? "",
            ocrDraftStatus: .suggested
        )
    }

    func makeExpense(
        tripID: UUID,
        baseCurrencyCode: String,
        currencyService: CurrencyConversionService,
        forcedStatus: OCRDraftStatus
    ) -> Expense? {
        guard let originalAmount = DecimalParser.parse(amountText), originalAmount > 0 else { return nil }

        let exchangeRate = currencyCode == baseCurrencyCode
            ? Decimal.one
            : (DecimalParser.parse(exchangeRateText) ?? currencyService.snapshotRate(from: currencyCode, to: baseCurrencyCode))

        let convertedAmount = currencyService.convert(
            originalAmount,
            from: currencyCode,
            to: baseCurrencyCode,
            using: exchangeRate
        )

        return Expense(
            tripID: tripID,
            originalAmount: originalAmount,
            originalCurrencyCode: currencyCode,
            convertedAmount: convertedAmount,
            exchangeRateSnapshot: exchangeRate,
            category: category,
            merchantName: merchantName,
            note: note,
            occurredAt: occurredAt,
            receiptImagePath: receiptImagePath.isEmpty ? nil : receiptImagePath,
            ocrDraftStatus: forcedStatus
        )
    }
}

