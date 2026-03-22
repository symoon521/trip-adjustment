import Foundation

protocol CurrencyConversionService {
    func snapshotRate(from sourceCode: String, to targetCode: String) -> Decimal
    func convert(_ amount: Decimal, from sourceCode: String, to targetCode: String, using rate: Decimal) -> Decimal
}

struct StaticCurrencyConversionService: CurrencyConversionService {
    private let rates: [String: Decimal] = [
        "JPY:USD": Decimal(string: "0.0068") ?? 1,
        "EUR:USD": Decimal(string: "1.08") ?? 1,
        "KRW:USD": Decimal(string: "0.00075") ?? 1,
        "USD:KRW": Decimal(string: "1333.33") ?? 1,
        "USD:JPY": Decimal(string: "147.00") ?? 1
    ]

    func snapshotRate(from sourceCode: String, to targetCode: String) -> Decimal {
        if sourceCode == targetCode {
            return .one
        }

        return rates["\(sourceCode):\(targetCode)"] ?? .one
    }

    func convert(_ amount: Decimal, from sourceCode: String, to targetCode: String, using rate: Decimal) -> Decimal {
        if sourceCode == targetCode {
            return amount
        }

        return amount * rate
    }
}

