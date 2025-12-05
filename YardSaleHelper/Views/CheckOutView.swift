//
//  CheckOutView.swift
//  YardSaleHelper
//
//  Created by Matthew DiNovo on 12/3/25.
//

import SwiftUI
import SwiftData

struct CheckOutView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var total: Double = 0.00
    @State private var showSellerSheet: Bool = false
    @State private var sellerName: String = ""
    @State private var sellerNotes: String = ""
    @State private var sellers: [String] = ["Alice", "Bob", "Charlie", "Dana"]
    @State private var selectedSellerIndex: Int = 0
    @State private var showCustomAmountSheet: Bool = false
    @State private var customAmountText: String = ""
    @State private var newSellerName: String = ""
    @FocusState private var isNewSellerFieldFocused: Bool
    
    @State private var sellerTotals: [String: Double] = [:]
    @State private var lastAddedAmount: Double = 0
    
    private func roundToCents(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("TOTAL: $\(String(format: "%.2f", total))")
                
                if !sellerTotals.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Seller Totals")
                            .font(.headline)
                        ForEach(sellers, id: \.self) { name in
                            if let amount = sellerTotals[name] {
                                Text("\(name): $\(String(format: "%.2f", amount))")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                
                VStack {
                    HStack {
                        Button("$0.10") {
                            total = roundToCents(total + 0.10)
                            lastAddedAmount = 0.10
                            showSellerSheet = true
                        }
                        Button("$0.25") {
                            //TODO: Add function to pop up to give Seller Info
                            total = roundToCents(total + 0.25)
                            lastAddedAmount = 0.25
                            showSellerSheet = true
                        }
                        Button("$0.50") {
                            //TODO: Add function to pop up to give Seller Info
                            total = roundToCents(total + 0.50)
                            lastAddedAmount = 0.50
                            showSellerSheet = true
                        }
                        Button("$1.00") {
                            //TODO: Add function to pop up to give Seller Info
                            total = roundToCents(total + 1.00)
                            lastAddedAmount = 1.00
                            showSellerSheet = true
                        }
                        
                    }
                    .buttonStyle(.glassProminent)
                    .padding(16)
                 
                    Button("Custom Amount") {
                      showCustomAmountSheet = true
                    }
                   
                    
                }
                
                
                
                
                Spacer()
                HStack(spacing: 16) {
                    NavigationLink(destination: CashView()) {
                        Text("Pay with Cash")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    NavigationLink(destination: CreditView()) {
                        Text("Pay with Credit")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }

                }
                .padding(.bottom, 50)
            }
            .sheet(isPresented: $showSellerSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Seller Information")) {
                            Picker("Seller", selection: $selectedSellerIndex) {
                                ForEach(sellers.indices, id: \.self) { index in
                                    Text(sellers[index]).tag(index)
                                }
                            }
                            TextField("Notes", text: $sellerNotes, axis: .vertical)
                                .lineLimit(3, reservesSpace: true)
                        }
                        Section(header: Text("Create New Seller")) {
                            HStack {
                                TextField("New seller name", text: $newSellerName)
                                    .textInputAutocapitalization(.words)
                                    .autocorrectionDisabled(false)
                                    .submitLabel(.done)
                                    .onSubmit {
                                        let trimmed = newSellerName.trimmingCharacters(in: .whitespacesAndNewlines)
                                        guard !trimmed.isEmpty else { return }
                                        if !sellers.contains(trimmed) {
                                            sellers.append(trimmed)
                                        }
                                        if let newIndex = sellers.firstIndex(of: trimmed) {
                                            selectedSellerIndex = newIndex
                                        }
                                        newSellerName = ""
                                        isNewSellerFieldFocused = false
                                    }
                                    .focused($isNewSellerFieldFocused)
                                Button("Add") {
                                    let trimmed = newSellerName.trimmingCharacters(in: .whitespacesAndNewlines)
                                    guard !trimmed.isEmpty else { return }
                                    if !sellers.contains(trimmed) {
                                        sellers.append(trimmed)
                                    }
                                    if let newIndex = sellers.firstIndex(of: trimmed) {
                                        selectedSellerIndex = newIndex
                                    }
                                    newSellerName = ""
                                    isNewSellerFieldFocused = false
                                }
                                .disabled(newSellerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                    }
                    .onAppear { isNewSellerFieldFocused = true }
                    .navigationTitle("Seller Info")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showSellerSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                // Persist selected seller name into sellerName for downstream use
                                if sellers.indices.contains(selectedSellerIndex) {
                                    sellerName = sellers[selectedSellerIndex]
                                }
                                // TODO: Persist seller info with this transaction if needed
                                let name = sellers.indices.contains(selectedSellerIndex) ? sellers[selectedSellerIndex] : sellerName
                                let current = sellerTotals[name] ?? 0
                                sellerTotals[name] = roundToCents(current + lastAddedAmount)
                                lastAddedAmount = 0
                                showSellerSheet = false
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showCustomAmountSheet) {
                NavigationStack {
                    Form {
                        Section(header: Text("Enter Custom Amount")) {
                            HStack {
                                Text("$")
                                TextField("0.00", text: $customAmountText)
                                    .keyboardType(.decimalPad)
                            }
                        }
                    }
                    .navigationTitle("Custom Amount")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                customAmountText = ""
                                showCustomAmountSheet = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                let amount = Double(customAmountText.replacingOccurrences(of: ",", with: "")) ?? 0
                                if amount > 0 {
                                    total = roundToCents(total + amount)
                                    lastAddedAmount = amount
                                    // After adding, prompt for seller info
                                    showSellerSheet = true
                                }
                                customAmountText = ""
                                showCustomAmountSheet = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("Check Out")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New Sale") {
                        // Persist current seller totals as Sale records
                        let now = Date()
                        for (name, amount) in sellerTotals {
                            guard amount > 0 else { continue }
                            // Convert Double to Decimal safely
                            let decimalAmount = Decimal(string: String(format: "%.2f", amount)) ?? Decimal(amount)
                            let sale = Sale(sellerName: name, amount: decimalAmount, date: now)
                            modelContext.insert(sale)
                        }
                        // Attempt to save the context
                        try? modelContext.save()

                        // Reset checkout state for a new sale
                        total = 0.0
                        sellerTotals.removeAll()
                        lastAddedAmount = 0
                        sellerNotes = ""
                        customAmountText = ""
                    }
                }
            }
            
        }
    }
}


#Preview {
    CheckOutView()
}

