//
//  CheckOutView.swift
//  YardSaleHelper
//
//  Created by Matthew DiNovo on 12/3/25.
//

import SwiftUI

struct CheckOutView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var total: Double = 0.00
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("TOTAL: $\(Int(total))")
                
                
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
            .navigationTitle("Check Out")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}


#Preview {
    CheckOutView()
}
