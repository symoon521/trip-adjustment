import Foundation

struct Expense: Identifiable, Codable, Hashable {
    let id: UUID
    let tripID: UUID
    var originalAmount: Decimal
    var originalCurrencyCode: String
    var convertedAmount: Decimal
    var exchangeRateSnapshot: Decimal
    var category: ExpenseCategory
    var merchantName: String
    var note: String
    var occurredAt: Date
    var receiptImagePath: String?
    var ocrDraftStatus: OCRDraftStatus
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        tripID: UUID,
        originalAmount: Decimal,
        originalCurrencyCode: String,
        convertedAmount: Decimal,
        exchangeRateSnapshot: Decimal,
        category: ExpenseCategory,
        merchantName: String,
        note: String,
        occurredAt: Date,
        receiptImagePath: String?,
        ocrDraftStatus: OCRDraftStatus,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.tripID = tripID
        self.originalAmount = originalAmount
        self.originalCurrencyCode = originalCurrencyCode
        self.convertedAmount = convertedAmount
        self.exchangeRateSnapshot = exchangeRateSnapshot
        self.category = category
        self.merchantName = merchantName
        self.note = note
        self.occurredAt = occurredAt
        self.receiptImagePath = receiptImagePath
        self.ocrDraftStatus = ocrDraftStatus
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum ExpenseCategory: String, CaseIterable, Codable, Identifiable {
    case food
    case transport
    case lodging
    case shopping
    case activities
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .food:
            return "Food"
        case .transport:
            return "Transport"
        case .lodging:
            return "Lodging"
        case .shopping:
            return "Shopping"
        case .activities:
            return "Activities"
        case .other:
            return "Other"
        }
    }
}

enum OCRDraftStatus: String, Codable {
    case none
    case suggested
    case confirmed
    case failed
}

