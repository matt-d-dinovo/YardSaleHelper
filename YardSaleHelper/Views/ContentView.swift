//
//  ContentView.swift
//  YardSaleHelper
//
//  Created by Matthew DiNovo on 12/3/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SellerView()
                .tabItem {
                    Label("Sellers",  systemImage: "person.crop.circle")
                }
            
            CheckOutView()
                .tabItem {
                    Label("Checkout", systemImage: "dollarsign.circle")
                }
            
            SellersEarnings()
                .tabItem {
                    Label("Earnings", systemImage: "chart.bar")
                }
            
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
           
        }
    }
}

#Preview {
    ContentView()
}
