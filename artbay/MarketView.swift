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
    var filteredItems: [Item] {
        let items = marketType == 0 ? Item.demoArtItems : Item.demoSpaceItems
        var filtered = items
        if let selected = selectedCategory, selected.name != "All" {
            filtered = filtered.filter { $0.category == selected.name }
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
            VStack(alignment: .leading, spacing: 20) {
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
                    selectedPriceRange: $selectedPriceRange,
                    sortOption: $sortOption,
                    priceRange: priceRange,
                    sortOptions: sortOptions,
                    categories: categories
                )
                .onAppear {
                    selectedPriceRange = priceRange
                }
                // Grid of items
                MarketGrid(items: filteredItems, expandedItemID: $expandedItemID, onExpand: { id in expandedItemID = id }, marketType: marketType)
            }
            .padding([.horizontal, .bottom])
            .onTapGesture { hideKeyboard() }
        }
    }
}

struct MarketSearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search items...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .onSubmit { isFocused = false }
            if !searchText.isEmpty {
                Button(action: { searchText = ""; isFocused = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .onTapGesture { isFocused = true }
    }
}

struct MarketFilterBar: View {
    @Binding var selectedCategory: Category?
    @Binding var selectedPriceRange: ClosedRange<Double>
    @Binding var sortOption: String
    let priceRange: ClosedRange<Double>
    let sortOptions: [String]
    let categories: [Category]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
            VStack(alignment: .leading, spacing: 8) {
                Text("Price Range")
                    .font(.caption)
                    .foregroundColor(.gray)
                RangeSlider(range: $selectedPriceRange, bounds: priceRange)
                HStack {
                    Text("$\(Int(selectedPriceRange.lowerBound))")
                    Spacer()
                    Text("$\(Int(selectedPriceRange.upperBound))")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            Picker("Sort", selection: $sortOption) {
                ForEach(sortOptions, id: \ .self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let minValue = bounds.lowerBound
            let maxValue = bounds.upperBound
            let lower = CGFloat((range.lowerBound - minValue) / (maxValue - minValue)) * width
            let upper = CGFloat((range.upperBound - minValue) / (maxValue - minValue)) * width
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 6)
                Capsule()
                    .fill(Color("AccentColor"))
                    .frame(width: upper - lower, height: 6)
                    .offset(x: lower)
                Circle()
                    .fill(Color("AccentColor"))
                    .frame(width: 24, height: 24)
                    .offset(x: lower - 12)
                    .gesture(DragGesture().onChanged { value in
                        let percent = min(max(0, value.location.x / width), 1)
                        let newValue = minValue + Double(percent) * (maxValue - minValue)
                        if newValue < range.upperBound {
                            range = newValue...range.upperBound
                        }
                    })
                Circle()
                    .fill(Color("AccentColor"))
                    .frame(width: 24, height: 24)
                    .offset(x: upper - 12)
                    .gesture(DragGesture().onChanged { value in
                        let percent = min(max(0, value.location.x / width), 1)
                        let newValue = minValue + Double(percent) * (maxValue - minValue)
                        if newValue > range.lowerBound {
                            range = range.lowerBound...newValue
                        }
                    })
            }
            .frame(height: 24)
        }
        .frame(height: 24)
    }
}

struct MarketItemCard: View {
    let item: Item
    var expanded: Bool = false
    var onExpand: () -> Void = {}
    var onAction: () -> Void = {}
    var marketType: Int = 0
    @State private var selectedImage = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
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
                if marketType == 0 {
                    Text("+ $\(String(format: "%.2f", item.priceIncrement)) per bid")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            Button(action: { onAction() }) {
                HStack {
                    Spacer()
                    Image(systemName: marketType == 0 ? "gavel" : "calendar")
                    Text(marketType == 0 ? "Bid $\(String(format: "%.2f", item.currentPrice))" : "Rent $\(String(format: "%.2f", item.basePrice))")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(Color("AccentColor"))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.top, 6)
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
    var marketType: Int
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
                            MarketItemCard(item: item, expanded: true, onExpand: { onExpand(nil) }, onAction: {}, marketType: marketType)
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .top))
                                .zIndex(1)
                                .onTapGesture { onExpand(nil) }
                        } else {
                            MarketItemCard(item: item, expanded: false, onExpand: { onExpand(itemUUID) }, onAction: {}, marketType: marketType)
                                .zIndex(0)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
