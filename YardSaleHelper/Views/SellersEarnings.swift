//
//  SellersEarnings.swift
//  YardSaleHelper
//
//  Created by Matthew DiNovo on 12/3/25.
//

import SwiftUI
import SwiftData

struct SellersEarnings: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\Sale.date, order: .reverse)]) private var sales: [Sale]

    private var totalBySeller: [(seller: String, total: Decimal)] {
        let grouped = Dictionary(grouping: sales, by: { $0.sellerName })
        let mapped: [(String, Decimal)] = grouped.map { key, values in
            let sum = values.reduce(Decimal(0)) { partial, sale in partial + sale.amount }
            return (key, sum)
        }
        return mapped.sorted { lhs, rhs in
            if lhs.1 == rhs.1 { return lhs.0 < rhs.0 }
            return lhs.1 > rhs.1
        }
    }

    private var grandTotal: Decimal {
        sales.reduce(Decimal(0)) { $0 + $1.amount }
    }

    var body: some View {
        NavigationStack {
            List {
                if sales.isEmpty {
                    ContentUnavailableView("No sales yet", systemImage: "dollarsign.circle", description: Text("Sales you record in checkout will appear here."))
                } else {
                    Section("Totals by seller") {
                        ForEach(totalBySeller, id: \.seller) { entry in
                            HStack {
                                Text(entry.seller)
                                Spacer()
                                Text(entry.total.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                                    .monospacedDigit()
                                    .fontWeight(.semibold)
                            }
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(entry.seller) total")
                            .accessibilityValue(entry.total.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                        }
                    }

                    Section("Recent sales") {
                        ForEach(sales) { sale in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(sale.sellerName)
                                        .font(.headline)
                                    Text(sale.date, style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(sale.amount.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                                    .monospacedDigit()
                            }
                        }
                        .onDelete(perform: delete)
                    }
                }
            }
            .navigationTitle("Earnings")
            .toolbar { EditButton() }
            .safeAreaInset(edge: .bottom) {
                if !sales.isEmpty {
                    HStack {
                        Text("Grand total")
                            .font(.headline)
                        Spacer()
                        Text(grandTotal.formatted(.currency(code: Locale.current.currency?.identifier ?? "USD")))
                            .font(.title3.weight(.bold))
                            .monospacedDigit()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    .background(.thinMaterial)
                }
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(sales[index]) }
        try? modelContext.save()
    }
}

#Preview {
    SellersEarnings()
        .modelContainer(for: Sale.self, inMemory: true)
}
