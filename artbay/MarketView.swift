//
//  SellView.swift
//  artbay
//
//  Created by user on 19/6/2025.
//

import SwiftUI
import UIKit
import SwiftData

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
    @State private var scrollOffset: CGFloat = 0
    
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
        
        // Filter by category
        var filtered = items
        if let selected = selectedCategory, selected.name != "All" {
            filtered = filtered.filter { $0.category == selected.name }
        }
        
        // Filter by price range
        filtered = filtered.filter { 
            $0.basePrice >= selectedPriceRange.lowerBound && 
            $0.basePrice <= selectedPriceRange.upperBound 
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) || 
                $0.itemDescription.localizedCaseInsensitiveContains(searchText) 
            }
        }
        
        // Sort items
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
            VStack(alignment: .leading, spacing: 0) {
                // Shrinking Header
                let minHeaderHeight: CGFloat = 44
                let maxHeaderHeight: CGFloat = 72
                let minFont: CGFloat = 20
                let maxFont: CGFloat = 34
                let minIcon: CGFloat = 22
                let maxIcon: CGFloat = 32
                let shrink = min(max(scrollOffset / 60, 0), 1)
                HStack {
                    Image(systemName: "cart")
                        .font(.system(size: maxIcon - (maxIcon - minIcon) * shrink))
                        .foregroundColor(Color("AccentColor"))
                    Text("Marketplace")
                        .font(.system(size: maxFont - (maxFont - minFont) * shrink, weight: .bold))
                    Spacer()
                }
                .frame(height: maxHeaderHeight - (maxHeaderHeight - minHeaderHeight) * shrink)
                .padding(.top, 8 - 4 * shrink)
                // Market type picker
                Picker(selection: $marketType, label: Text("Market Type")) {
                    Text("Art Work").tag(0)
                    Text("Space").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .scaleEffect(1 - 0.15 * shrink)
                .padding(.vertical, 4 - 2 * shrink)
                // Shrinking search/filter
                VStack(spacing: 8 - 4 * shrink) {
                    MarketSearchBar(searchText: $searchText, compact: shrink > 0.5)
                    MarketFilterBar(
                        selectedCategory: $selectedCategory,
                        selectedPriceRange: $selectedPriceRange,
                        sortOption: $sortOption,
                        priceRange: priceRange,
                        sortOptions: sortOptions,
                        categories: categories,
                        compact: shrink > 0.5
                    )
                    .onAppear {
                        selectedPriceRange = priceRange
                    }
                }
                .padding(.bottom, 8 - 4 * shrink)
                // Scrollable grid with offset tracking
                ScrollView {
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scroll")).minY)
                    }
                    .frame(height: 0)
                    MarketGrid(items: filteredItems, expandedItemID: $expandedItemID, onExpand: { id in expandedItemID = id }, marketType: marketType)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = -value
                }
            }
            .padding([.horizontal, .bottom])
            .onTapGesture { hideKeyboard() }
            .onAppear {
                selectedPriceRange = priceRange
            }
            .onChange(of: marketType) { oldValue, newValue in
                selectedPriceRange = priceRange
            }
            .onChange(of: priceRange) { oldValue, newValue in
                selectedPriceRange = priceRange
            }
        }
    }
}

// PreferenceKey for scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MarketSearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    var compact: Bool = false
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search items...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .onSubmit { isFocused = false }
                .font(compact ? .subheadline : .body)
            if !searchText.isEmpty {
                Button(action: { searchText = ""; isFocused = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(compact ? 6 : 10)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(compact ? 8 : 10)
        .scaleEffect(compact ? 0.95 : 1)
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
    var compact: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 6 : 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: compact ? 6 : 10) {
                    ForEach(categories) { category in
                        Button(action: {
                            selectedCategory = selectedCategory == category ? nil : category
                        }) {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(compact ? .caption : .subheadline)
                                Text(category.name)
                                    .font(compact ? .caption2 : .caption)
                            }
                            .padding(.vertical, compact ? 6 : 8)
                            .padding(.horizontal, compact ? 10 : 14)
                            .background(selectedCategory == category ? Color("AccentColor") : Color(.systemGray5))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .overlay(
                                RoundedRectangle(cornerRadius: compact ? 12 : 16)
                                    .stroke(selectedCategory == category ? Color("AccentColor") : Color(.systemGray4), lineWidth: 1)
                            )
                            .cornerRadius(compact ? 12 : 16)
                            .shadow(color: selectedCategory == category ? Color("AccentColor").opacity(0.2) : .clear, radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 2)
            }
            HStack(alignment: .center, spacing: compact ? 8 : 16) {
                // Price Range (left)
                VStack(alignment: .leading, spacing: compact ? 2 : 6) {
                    Text("Max Price")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: compact ? 4 : 8) {
                        Text("$\(Int(priceRange.lowerBound))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(minWidth: 40, alignment: .leading)
                        Slider(value: Binding(
                            get: { selectedPriceRange.upperBound },
                            set: { newValue in
                                selectedPriceRange = priceRange.lowerBound...newValue
                            }
                        ), in: priceRange, step: 1)
                        .accentColor(Color("AccentColor"))
                        .frame(minWidth: compact ? 80 : 120, maxWidth: compact ? 140 : 220)
                        Text("$\(Int(selectedPriceRange.upperBound))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(minWidth: 40, alignment: .trailing)
                    }
                }
                // Sorting (right)
                Spacer()
                Picker("Sort", selection: $sortOption) {
                    ForEach(sortOptions, id: \ .self) { option in
                        Text(option)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: compact ? 90 : 140)
                .scaleEffect(compact ? 0.92 : 1)
            }
        }
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
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 16),
            GridItem(.flexible(), spacing: 16)
        ], spacing: 16) {
            ForEach(items) { item in
                let itemID = item.id
                if expandedItemID == itemID {
                    MarketItemCard(item: item, expanded: true, onExpand: { onExpand(nil) }, onAction: {}, marketType: marketType)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .top))
                        .zIndex(1)
                        .onTapGesture { onExpand(nil) }
                } else {
                    MarketItemCard(item: item, expanded: false, onExpand: { onExpand(itemID) }, onAction: {}, marketType: marketType)
                        .zIndex(0)
                }
            }
        }
        .padding(.top, 8)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    MarketView()
}
