//
//  ContentView.swift
//  artbay
//
//  Created by user on 17/6/2025.
//

import SwiftUI
//import SwiftData

struct ContentView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("Feed", systemImage: "text.rectangle.page")
                }
                .tag(0)
            MarketView()
                .tabItem {
                    Label("Market", systemImage: "cart.fill")
                }
                .tag(1)
            SellView()
                .tabItem {
                    Label("Sell", systemImage: "plus.circle.fill")
                }
                .tag(2)
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "list.bullet.rectangle.fill")
                }
                .tag(3)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(4)
        }
        .accentColor(Color("AccentColor"))
    }
}

#Preview {
    ContentView()
}
