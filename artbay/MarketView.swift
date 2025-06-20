//
//  SellView.swift
//  artbay
//
//  Created by user on 19/6/2025.
//

import SwiftUI
import UIKit

struct Category: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String // systemName for SF Symbol
}

struct SellItem: Identifiable {
    let id = UUID()
    let userName: String
    let userIcon: String // systemName for SF Symbol
    let startTime: Date
    let description: String
    let images: [String] // image names
    let basePrice: Double
    let increment: Double
    var currentPrice: Double
}

struct MarketView: View {
    // MARK: - State
    @State private var marketType: Int = 0
    @State private var selectedCategory: Category? = nil
    @State private var expandedItemID: UUID? = nil
    @State private var searchText: String = ""
    @State private var selectedArtist: String? = nil
    @State private var selectedPriceRange: ClosedRange<Double> = 0...10000
    @State private var minPrice: Double = 0
    @State private var maxPrice: Double = 10000
    @State private var sortOption: String = "Newest"
    
    let sortOptions = ["Newest", "Price: Low to High", "Price: High to Low", "Popularity"]
    let artCategories: [Category] = [
        Category(name: "All", icon: "square.grid.2x2"),
        Category(name: "Painting", icon: "paintpalette"),
        Category(name: "Sculpture", icon: "cube"),
        Category(name: "Photography", icon: "camera"),
        Category(name: "Digital", icon: "desktopcomputer")
    ]
    let spaceCategories: [Category] = [
        Category(name: "All", icon: "square.grid.2x2"),
        Category(name: "Gallery", icon: "building.columns"),
        Category(name: "Cafe Wall", icon: "cup.and.saucer"),
        Category(name: "Pop-up", icon: "shippingbox"),
        Category(name: "Outdoor", icon: "leaf")
    ]
    var categories: [Category] {
        marketType == 0 ? artCategories : spaceCategories
    }
    var allArtists: [String] {
        Set(filteredItems.map { $0.artist }).sorted()
    }
    var filteredItems: [Item] {
        let items = marketType == 0 ? Item.demoArtItems : Item.demoSpaceItems
        var filtered = items
        if let selected = selectedCategory, selected.name != "All" {
            filtered = filtered.filter { $0.category == selected.name }
        }
        if let artist = selectedArtist {
            filtered = filtered.filter { $0.artist == artist }
        }
        filtered = filtered.filter { $0.basePrice >= selectedPriceRange.lowerBound && $0.basePrice <= selectedPriceRange.upperBound }
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.itemDescription.localizedCaseInsensitiveContains(searchText) }
        }
        switch sortOption {
        case "Price: Low to High":
            filtered = filtered.sorted { $0.basePrice < $1.basePrice }
        case "Price: High to Low":
            filtered = filtered.sorted { $0.basePrice > $1.basePrice }
        case "Popularity":
            filtered = filtered.sorted { $0.popularity > $1.popularity }
        default:
            filtered = filtered.sorted { $0.timestamp > $1.timestamp }
        }
        return filtered
    }
    var priceRange: ClosedRange<Double> {
        let items = marketType == 0 ? Item.demoArtItems : Item.demoSpaceItems
        let minPrice = items.map { $0.basePrice }.min() ?? 0
        let maxPrice = items.map { $0.basePrice }.max() ?? 10000
        return minPrice...maxPrice
    }
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "cart")
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                    Text("Marketplace")
                        .font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.top, 8)
                // Market type picker
                Picker(selection: $marketType, label: Text("Market Type")) {
                    Text("Art Work").tag(0)
                    Text("Space").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                // Search bar
                MarketSearchBar(searchText: $searchText)
                // Filter bar
                MarketFilterBar(
                    selectedCategory: $selectedCategory,
                    selectedArtist: $selectedArtist,
                    minPrice: $minPrice,
                    maxPrice: $maxPrice,
                    sortOption: $sortOption,
                    allArtists: allArtists,
                    priceRange: priceRange,
                    sortOptions: sortOptions,
                    categories: categories
                )
                .onAppear {
                    minPrice = priceRange.lowerBound
                    maxPrice = priceRange.upperBound
                    selectedPriceRange = minPrice...maxPrice
                }
                // Grid of items
                MarketGrid(items: filteredItems, expandedItemID: $expandedItemID, onExpand: { id in expandedItemID = id })
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct MarketSearchBar: View {
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search items...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct MarketFilterBar: View {
    @Binding var selectedCategory: Category?
    @Binding var selectedArtist: String?
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    @Binding var sortOption: String
    let allArtists: [String]
    let priceRange: ClosedRange<Double>
    let sortOptions: [String]
    let categories: [Category]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories) { category in
                        Button(action: {
                            selectedCategory = selectedCategory == category ? nil : category
                        }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.subheadline)
                                Text(category.name)
                                    .font(.caption)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(selectedCategory == category ? Color("AccentColor") : Color(.systemGray5))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedCategory == category ? Color("AccentColor") : Color(.systemGray4), lineWidth: 1)
                            )
                            .cornerRadius(16)
                            .shadow(color: selectedCategory == category ? Color("AccentColor").opacity(0.2) : .clear, radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 2)
            }
            HStack(spacing: 16) {
                Menu {
                    Button("All Artists") { selectedArtist = nil }
                    ForEach(allArtists, id: \ .self) { artist in
                        Button(artist) { selectedArtist = artist }
                    }
                } label: {
                    Label(selectedArtist ?? "All Artists", systemImage: "person.2")
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }
                HStack {
                    Text("$\(Int(minPrice))")
                    Slider(value: $minPrice, in: priceRange, step: 1)
                    Slider(value: $maxPrice, in: priceRange, step: 1)
                    Text("$\(Int(maxPrice))")
                }
                .frame(maxWidth: 220)
                Picker("Sort", selection: $sortOption) {
                    ForEach(sortOptions, id: \ .self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .font(.caption)
        }
    }
}

struct MarketItemCard: View {
    let item: Item
    var expanded: Bool = false
    var onExpand: () -> Void = {}
    var onAuctionBuy: () -> Void = {}
    @State private var selectedImage = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let path = item.imagePath, let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: expanded ? 220 : 140)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(14)
            } else {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: expanded ? 220 : 140)
                    .cornerRadius(14)
            }
            Text(item.title)
                .font(.headline)
                .lineLimit(1)
            Text(item.itemDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(expanded ? nil : 2)
                .animation(.easeInOut, value: expanded)
            HStack {
                Text("Category: \(item.category)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
                Text(item.timestamp, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            HStack(spacing: 8) {
                Text("Base: $\(String(format: "%.2f", item.basePrice))")
                    .font(.caption)
                    .bold()
                Text("+ $\(String(format: "%.2f", item.priceIncrement)) per bid")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            HStack {
                Button(action: { onAuctionBuy() }) {
                    HStack {
                        Image(systemName: "gavel")
                        Text(item.isAuction ? "Bid $\(String(format: "%.2f", item.currentPrice))" : "Buy $\(String(format: "%.2f", item.basePrice))")
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color("AccentColor"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .onTapGesture {
            onExpand()
        }
        .animation(.spring(), value: expanded)
    }
}

struct MarketGrid: View {
    let items: [Item]
    @Binding var expandedItemID: UUID?
    var onExpand: (UUID?) -> Void = { _ in }
    var body: some View {
        GeometryReader { geometry in
            let minCardWidth: CGFloat = 220
            let spacing: CGFloat = 16
            let totalWidth = geometry.size.width - spacing
            let columnCount = max(Int(totalWidth / (minCardWidth + spacing)), 1)
            let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(items) { item in
                        let itemUUID = item.id as? UUID
                        if expandedItemID == itemUUID {
                            MarketItemCard(item: item, expanded: true, onExpand: { onExpand(nil) })
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .top))
                                .zIndex(1)
                                .onTapGesture { onExpand(nil) }
                        } else {
                            MarketItemCard(item: item, expanded: false, onExpand: { onExpand(itemUUID) })
                                .zIndex(0)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}
