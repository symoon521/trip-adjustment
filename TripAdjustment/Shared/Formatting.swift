import Foundation

enum DecimalParser {
    static func parse(_ value: String) -> Decimal? {
        let cleaned = value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        return Decimal(string: cleaned)
    }
}

extension Decimal {
    static let one = Decimal(integerLiteral: 1)

    func currencyString(code: String, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        formatter.locale = locale
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? "\(self)"
    }

    func numberString(maximumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: NSDecimalNumber(decimal: self)) ?? "\(self)"
    }
}

extension Double {
    func percentString(maximumFractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "0%"
    }
}

