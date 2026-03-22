import SwiftUI

struct SummaryCardView: View {
    let summary: TripSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(summary.tripName)
                .font(.title2.weight(.semibold))

            HStack {
                summaryMetric(title: "Spent", value: summary.spentAmount.currencyString(code: summary.baseCurrencyCode))
                summaryMetric(title: "Remaining", value: summary.remainingAmount.currencyString(code: summary.baseCurrencyCode))
            }

            summaryMetric(title: "Budget", value: summary.budgetAmount.currencyString(code: summary.baseCurrencyCode))

            ProgressView(value: min(summary.usageRate, 1))
            Text(summary.usageRate.percentString())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryMetric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

