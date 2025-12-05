import Foundation
import SwiftData

@Model
final class Sale {
    @Attribute(.unique) var id: UUID
    var sellerName: String
    var amount: Decimal
    var date: Date

    init(id: UUID = UUID(), sellerName: String, amount: Decimal, date: Date = .now) {
        self.id = id
        self.sellerName = sellerName
        self.amount = amount
        self.date = date
    }
}

extension Sale {
    // Convenience API you can call from CheckOutView when a sale completes
    static func record(sellerName: String, amount: Decimal, modelContext: ModelContext) throws {
        let sale = Sale(sellerName: sellerName, amount: amount)
        modelContext.insert(sale)
        try modelContext.save()
    }
}

@Model
final class CompletedSale {
    @Attribute(.unique) var id: UUID
    var buyerName: String
    var amount: Decimal
    var completionDate: Date

    init(id: UUID = UUID(), buyerName: String, amount: Decimal, completionDate: Date = .now) {
        self.id = id
        self.buyerName = buyerName
        self.amount = amount
        self.completionDate = completionDate
    }
}
