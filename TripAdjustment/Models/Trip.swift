import Foundation

struct Trip: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date
    var budgetAmount: Decimal
    var baseCurrencyCode: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        startDate: Date,
        endDate: Date,
        budgetAmount: Decimal,
        baseCurrencyCode: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.budgetAmount = budgetAmount
        self.baseCurrencyCode = baseCurrencyCode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct TripDraft {
    var name: String = ""
    var startDate: Date = Date()
    var endDate: Date = Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date()
    var budgetText: String = ""
    var baseCurrencyCode: String = "USD"

    func makeTrip() -> Trip? {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
        guard let budgetAmount = DecimalParser.parse(budgetText), budgetAmount > 0 else { return nil }
        return Trip(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            startDate: startDate,
            endDate: max(startDate, endDate),
            budgetAmount: budgetAmount,
            baseCurrencyCode: baseCurrencyCode
        )
    }
}

