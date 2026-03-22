import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var trips: [Trip]
    @Published var expenses: [Expense]
    @Published var selectedTripID: UUID?
    @Published var quickEntryDraft: ExpenseDraft
    @Published var receiptDraft: ExpenseDraft

    private let currencyService: CurrencyConversionService
    private let receiptOCRService: ReceiptOCRService

    init(
        trips: [Trip] = [],
        expenses: [Expense] = [],
        selectedTripID: UUID? = nil,
        quickEntryDraft: ExpenseDraft = .blank(defaultCurrencyCode: "USD"),
        receiptDraft: ExpenseDraft = .blank(defaultCurrencyCode: "USD"),
        currencyService: CurrencyConversionService = StaticCurrencyConversionService(),
        receiptOCRService: ReceiptOCRService = MockReceiptOCRService()
    ) {
        self.trips = trips
        self.expenses = expenses
        self.selectedTripID = selectedTripID ?? trips.first?.id
        self.quickEntryDraft = quickEntryDraft
        self.receiptDraft = receiptDraft
        self.currencyService = currencyService
        self.receiptOCRService = receiptOCRService
    }

    var selectedTrip: Trip? {
        guard let selectedTripID else { return trips.first }
        return trips.first(where: { $0.id == selectedTripID })
    }

    var selectedTripExpenses: [Expense] {
        guard let trip = selectedTrip else { return [] }
        return expenses
            .filter { $0.tripID == trip.id }
            .sorted(by: { $0.occurredAt > $1.occurredAt })
    }

    var selectedTripSummary: TripSummary? {
        guard let trip = selectedTrip else { return nil }
        let spent = selectedTripExpenses.reduce(Decimal.zero) { partialResult, expense in
            partialResult + expense.convertedAmount
        }

        return TripSummary(
            tripName: trip.name,
            baseCurrencyCode: trip.baseCurrencyCode,
            budgetAmount: trip.budgetAmount,
            spentAmount: spent
        )
    }

    func selectTrip(id: UUID) {
        selectedTripID = id
        syncDraftCurrencies()
    }

    func addTrip(from draft: TripDraft) -> Bool {
        guard let trip = draft.makeTrip() else { return false }
        trips.append(trip)
        selectedTripID = trip.id
        syncDraftCurrencies()
        return true
    }

    func deleteTrips(ids: Set<UUID>) {
        trips.removeAll { ids.contains($0.id) }
        expenses.removeAll { ids.contains($0.tripID) }

        if let selectedTripID, ids.contains(selectedTripID) {
            self.selectedTripID = trips.first?.id
            syncDraftCurrencies()
        }
    }

    func saveQuickEntry() -> Bool {
        saveExpense(from: quickEntryDraft, forcedStatus: .none) { [weak self] baseCurrencyCode in
            self?.quickEntryDraft = .blank(defaultCurrencyCode: baseCurrencyCode)
        }
    }

    func prepareReceiptDraft() {
        guard let trip = selectedTrip else { return }
        let suggestion = receiptOCRService.makeMockSuggestion(defaultCurrencyCode: trip.baseCurrencyCode)
        receiptDraft = ExpenseDraft.fromSuggestion(suggestion, defaultCurrencyCode: trip.baseCurrencyCode)
    }

    func saveReceiptDraft() -> Bool {
        saveExpense(from: receiptDraft, forcedStatus: .confirmed) { [weak self] baseCurrencyCode in
            self?.receiptDraft = .blank(defaultCurrencyCode: baseCurrencyCode)
        }
    }

    func deleteExpenses(ids: Set<UUID>) {
        expenses.removeAll { ids.contains($0.id) }
    }

    private func saveExpense(
        from draft: ExpenseDraft,
        forcedStatus: OCRDraftStatus,
        reset: (String) -> Void
    ) -> Bool {
        guard let trip = selectedTrip else { return false }
        guard let expense = draft.makeExpense(
            tripID: trip.id,
            baseCurrencyCode: trip.baseCurrencyCode,
            currencyService: currencyService,
            forcedStatus: forcedStatus
        ) else {
            return false
        }

        expenses.append(expense)
        reset(trip.baseCurrencyCode)
        return true
    }

    private func syncDraftCurrencies() {
        let baseCurrencyCode = selectedTrip?.baseCurrencyCode ?? "USD"
        quickEntryDraft.currencyCode = baseCurrencyCode
        quickEntryDraft.exchangeRateText = "1"
        receiptDraft.currencyCode = baseCurrencyCode
        receiptDraft.exchangeRateText = "1"
    }
}

struct TripSummary {
    let tripName: String
    let baseCurrencyCode: String
    let budgetAmount: Decimal
    let spentAmount: Decimal

    var remainingAmount: Decimal {
        budgetAmount - spentAmount
    }

    var usageRate: Double {
        let budget = NSDecimalNumber(decimal: budgetAmount).doubleValue
        guard budget > 0 else { return 0 }
        let spent = NSDecimalNumber(decimal: spentAmount).doubleValue
        return spent / budget
    }
}

extension AppState {
    static func sample() -> AppState {
        let trip = Trip(
            name: "Tokyo Spring Trip",
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            budgetAmount: 1200,
            baseCurrencyCode: "USD"
        )

        let expenses = [
            Expense(
                tripID: trip.id,
                originalAmount: 18,
                originalCurrencyCode: "USD",
                convertedAmount: 18,
                exchangeRateSnapshot: 1,
                category: .food,
                merchantName: "Airport Coffee",
                note: "Arrival morning",
                occurredAt: Date(),
                receiptImagePath: nil,
                ocrDraftStatus: .none
            ),
            Expense(
                tripID: trip.id,
                originalAmount: 3200,
                originalCurrencyCode: "JPY",
                convertedAmount: 21.76,
                exchangeRateSnapshot: 0.0068,
                category: .transport,
                merchantName: "Narita Express",
                note: "",
                occurredAt: Calendar.current.date(byAdding: .hour, value: -4, to: Date()) ?? Date(),
                receiptImagePath: "receipts/narita-express.jpg",
                ocrDraftStatus: .confirmed
            )
        ]

        return AppState(
            trips: [trip],
            expenses: expenses,
            selectedTripID: trip.id,
            quickEntryDraft: .blank(defaultCurrencyCode: trip.baseCurrencyCode),
            receiptDraft: .blank(defaultCurrencyCode: trip.baseCurrencyCode)
        )
    }
}
