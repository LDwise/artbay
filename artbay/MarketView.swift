//
//  SellView.swift
//  artbay
//
//  Created by user on 19/6/2025.
//

import SwiftUI

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

struct SellView: View {
    @State private var marketType: Int = 0
    @State private var selectedCategory: Category? = nil
    @State private var expandedItemID: UUID? = nil
    
    // Art Work categories and items
    let artCategories: [Category] = [
        Category(name: "Painting", icon: "paintpalette"),
        Category(name: "Sculpture", icon: "cube"),
        Category(name: "Photography", icon: "camera"),
        Category(name: "Digital", icon: "desktopcomputer"),
        Category(name: "Other", icon: "ellipsis")
    ]
    
    let artItems: [SellItem] = [
        SellItem(userName: "Alice", userIcon: "person.circle", startTime: Date().addingTimeInterval(-3600), description: "A beautiful landscape painting with vibrant colors and deep emotion.", images: ["photo", "photo.fill"], basePrice: 100, increment: 10, currentPrice: 120),
        SellItem(userName: "Bob", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-7200), description: "Modern sculpture made from recycled materials. Unique and eco-friendly.", images: ["cube", "cube.fill"], basePrice: 200, increment: 20, currentPrice: 220),
        SellItem(userName: "Carol", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-1800), description: "Limited edition digital artwork. Only 10 copies available!", images: ["desktopcomputer", "desktopcomputer"], basePrice: 50, increment: 5, currentPrice: 60),
        SellItem(userName: "David", userIcon: "person.circle", startTime: Date().addingTimeInterval(-4000), description: "Abstract painting with bold strokes and vibrant colors.", images: ["paintpalette", "scribble"], basePrice: 150, increment: 15, currentPrice: 180),
        SellItem(userName: "Eve", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-6000), description: "Black and white photography of city life.", images: ["camera", "camera.fill"], basePrice: 80, increment: 8, currentPrice: 96),
        SellItem(userName: "Frank", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-8000), description: "Digital illustration inspired by nature.", images: ["leaf", "desktopcomputer"], basePrice: 60, increment: 6, currentPrice: 72),
        SellItem(userName: "Grace", userIcon: "person.circle", startTime: Date().addingTimeInterval(-10000), description: "Sculpture made from recycled metal parts.", images: ["cube", "hammer"], basePrice: 220, increment: 22, currentPrice: 264),
        SellItem(userName: "Heidi", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-12000), description: "Colorful mural painting for public spaces.", images: ["paintbrush", "paintpalette"], basePrice: 300, increment: 30, currentPrice: 360),
        SellItem(userName: "Ivan", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-14000), description: "Minimalist digital art with geometric shapes.", images: ["square", "desktopcomputer"], basePrice: 70, increment: 7, currentPrice: 84),
        SellItem(userName: "Judy", userIcon: "person.circle", startTime: Date().addingTimeInterval(-16000), description: "Portrait painting in oil on canvas.", images: ["person", "paintpalette"], basePrice: 180, increment: 18, currentPrice: 216),
        SellItem(userName: "Karl", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-18000), description: "Street photography capturing urban moments.", images: ["camera", "photo"], basePrice: 90, increment: 9, currentPrice: 108),
        SellItem(userName: "Laura", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-20000), description: "Mixed media artwork with paper and paint.", images: ["doc", "paintbrush"], basePrice: 110, increment: 11, currentPrice: 132),
        SellItem(userName: "Mallory", userIcon: "person.circle", startTime: Date().addingTimeInterval(-22000), description: "Sculpture of a running horse in bronze.", images: ["cube", "hare"], basePrice: 400, increment: 40, currentPrice: 480),
        SellItem(userName: "Niaj", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-24000), description: "Digital collage with surreal elements.", images: ["desktopcomputer", "sparkles"], basePrice: 95, increment: 9.5, currentPrice: 114.5),
        SellItem(userName: "Olivia", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-26000), description: "Watercolor painting of a mountain landscape.", images: ["mountain", "paintpalette"], basePrice: 130, increment: 13, currentPrice: 156),
        SellItem(userName: "Peggy", userIcon: "person.circle", startTime: Date().addingTimeInterval(-28000), description: "Photography of wild animals in their habitat.", images: ["camera", "pawprint"], basePrice: 120, increment: 12, currentPrice: 144),
        SellItem(userName: "Quentin", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-30000), description: "Large abstract canvas with mixed colors.", images: ["paintpalette", "scribble.variable"], basePrice: 210, increment: 21, currentPrice: 252),
        SellItem(userName: "Rupert", userIcon: "person.crop.circle", startTime: Date().addingTimeInterval(-32000), description: "Digital portrait with vibrant lighting effects.", images: ["person", "desktopcomputer"], basePrice: 75, increment: 7.5, currentPrice: 90),
        SellItem(userName: "Sybil", userIcon: "person.circle", startTime: Date().addingTimeInterval(-34000), description: "Sculpture of a bird in flight.", images: ["cube", "bird"], basePrice: 250, increment: 25, currentPrice: 300),
        SellItem(userName: "Trent", userIcon: "person.circle.fill", startTime: Date().addingTimeInterval(-36000), description: "Digital painting of a futuristic cityscape.", images: ["building.2", "desktopcomputer"], basePrice: 160, increment: 16, currentPrice: 192)
    ]
    
    // Space categories and items
    let spaceCategories: [Category] = [
        Category(name: "Gallery", icon: "building.columns"),
        Category(name: "Cafe Wall", icon: "cup.and.saucer"),
        Category(name: "Pop-up", icon: "shippingbox"),
        Category(name: "Outdoor", icon: "leaf"),
        Category(name: "Other", icon: "ellipsis")
    ]
    
    let spaceItems: [SellItem] = [
        SellItem(userName: "Gallery One", userIcon: "building.columns", startTime: Date().addingTimeInterval(-3600), description: "Modern gallery in downtown, 100 sqm, lighting included.", images: ["building.columns", "photo"], basePrice: 500, increment: 50, currentPrice: 600),
        SellItem(userName: "Cafe Latte Art Wall", userIcon: "cup.and.saucer", startTime: Date().addingTimeInterval(-7200), description: "Feature wall in a busy cafe, perfect for small exhibitions.", images: ["cup.and.saucer", "photo"], basePrice: 100, increment: 10, currentPrice: 120),
        SellItem(userName: "Pop-up Space Central", userIcon: "shippingbox", startTime: Date().addingTimeInterval(-1800), description: "Temporary pop-up space, high foot traffic, flexible terms.", images: ["shippingbox", "photo"], basePrice: 300, increment: 20, currentPrice: 340),
        SellItem(userName: "Riverside Park", userIcon: "leaf", startTime: Date().addingTimeInterval(-5400), description: "Outdoor park area for open-air exhibitions.", images: ["leaf", "photo"], basePrice: 80, increment: 8, currentPrice: 96),
        SellItem(userName: "Art Hub Gallery", userIcon: "building.columns", startTime: Date().addingTimeInterval(-36000), description: "Spacious gallery with professional lighting and security.", images: ["building.columns", "photo"], basePrice: 700, increment: 70, currentPrice: 840),
        SellItem(userName: "Urban Loft Space", userIcon: "house", startTime: Date().addingTimeInterval(-9000), description: "Trendy loft, ideal for pop-up exhibitions and events.", images: ["house", "photo"], basePrice: 400, increment: 40, currentPrice: 480),
        SellItem(userName: "Community Center Hall", userIcon: "person.3", startTime: Date().addingTimeInterval(-12000), description: "Large hall, affordable rates for local artists.", images: ["person.3", "photo"], basePrice: 150, increment: 15, currentPrice: 180),
        SellItem(userName: "Seaside Cafe Wall", userIcon: "cup.and.saucer", startTime: Date().addingTimeInterval(-15000), description: "Wall space in a seaside cafe, great for photography.", images: ["cup.and.saucer", "photo"], basePrice: 90, increment: 9, currentPrice: 108),
        SellItem(userName: "Artisan Market Booth", userIcon: "cart", startTime: Date().addingTimeInterval(-18000), description: "Booth at weekend artisan market, high visibility.", images: ["cart", "photo"], basePrice: 60, increment: 6, currentPrice: 72),
        SellItem(userName: "Boutique Hotel Lobby", userIcon: "bed.double", startTime: Date().addingTimeInterval(-21000), description: "Lobby wall in boutique hotel, upscale clientele.", images: ["bed.double", "photo"], basePrice: 200, increment: 20, currentPrice: 240),
        SellItem(userName: "City Library Atrium", userIcon: "books.vertical", startTime: Date().addingTimeInterval(-24000), description: "Atrium space in city library, lots of natural light.", images: ["books.vertical", "photo"], basePrice: 120, increment: 12, currentPrice: 144),
        SellItem(userName: "Rooftop Garden Venue", userIcon: "leaf", startTime: Date().addingTimeInterval(-27000), description: "Rooftop garden, perfect for summer exhibitions.", images: ["leaf", "photo"], basePrice: 250, increment: 25, currentPrice: 300),
        SellItem(userName: "Warehouse Studio", userIcon: "shippingbox", startTime: Date().addingTimeInterval(-30000), description: "Industrial studio, customizable layout.", images: ["shippingbox", "photo"], basePrice: 350, increment: 35, currentPrice: 420),
        SellItem(userName: "Bookstore Nook", userIcon: "books.vertical", startTime: Date().addingTimeInterval(-33000), description: "Cozy nook in independent bookstore.", images: ["books.vertical", "photo"], basePrice: 70, increment: 7, currentPrice: 84),
        SellItem(userName: "Hotel Conference Room", userIcon: "bed.double", startTime: Date().addingTimeInterval(-36000), description: "Conference room, suitable for group exhibitions.", images: ["bed.double", "photo"], basePrice: 300, increment: 30, currentPrice: 360),
        SellItem(userName: "Outdoor Plaza", userIcon: "leaf", startTime: Date().addingTimeInterval(-39000), description: "Open plaza, high pedestrian traffic.", images: ["leaf", "photo"], basePrice: 180, increment: 18, currentPrice: 216),
        SellItem(userName: "Gallery Two", userIcon: "building.columns", startTime: Date().addingTimeInterval(-42000), description: "Contemporary gallery, central location.", images: ["building.columns", "photo"], basePrice: 600, increment: 60, currentPrice: 720),
        SellItem(userName: "Pop-up at Mall", userIcon: "shippingbox", startTime: Date().addingTimeInterval(-45000), description: "Pop-up booth in shopping mall, great exposure.", images: ["shippingbox", "photo"], basePrice: 220, increment: 22, currentPrice: 264),
        SellItem(userName: "Art School Studio", userIcon: "paintbrush", startTime: Date().addingTimeInterval(-48000), description: "Studio space in art school, creative environment.", images: ["paintbrush", "photo"], basePrice: 130, increment: 13, currentPrice: 156),
        SellItem(userName: "Cultural Center Gallery", userIcon: "building.columns", startTime: Date().addingTimeInterval(-51000), description: "Gallery in cultural center, supportive staff.", images: ["building.columns", "photo"], basePrice: 400, increment: 40, currentPrice: 480)
    ]
    
    var categories: [Category] {
        marketType == 0 ? artCategories : spaceCategories
    }
    
    var items: [SellItem] {
        marketType == 0 ? artItems : spaceItems
    }
    
    var filteredItems: [SellItem] {
        // For demo, just return all items. You can filter by category if needed.
        items
    }
    
    var gridColumns: [GridItem] {
        // 2 columns for normal, but enough columns to auto-wrap on wider screens
        Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Picker(selection: $marketType, label: Text("Market Type")) {
                Text("Art Work").tag(0)
                Text("Space").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // Category Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    ForEach(categories) { category in
                        Button(action: {
                            selectedCategory = selectedCategory == category ? nil : category
                        }) {
                            HStack() {
                                Image(systemName: category.icon)
                                    .font(.title2)
                                Text(category.name)
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(selectedCategory == category ? Color("AccentColor") : Color("AccentColor").opacity(0.5))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Item Grid
            GeometryReader { geometry in
                let minCardWidth: CGFloat = 220
                let spacing: CGFloat = 16
                let totalWidth = geometry.size.width - spacing // account for padding
                let columnCount = max(Int(totalWidth / (minCardWidth + spacing)), 1)
                let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(filteredItems) { item in
                            if expandedItemID == item.id {
                                SellItemCard(
                                    item: item,
                                    isExpanded: true,
                                    onExpand: {
                                        withAnimation {
                                            expandedItemID = nil
                                        }
                                    },
                                    isSpace: marketType == 1
                                )
                                .frame(maxWidth: .infinity)
                                .gridCellColumns(columnCount)
                                .transition(.scale.combined(with: .opacity))
                            } else {
                                SellItemCard(
                                    item: item,
                                    isExpanded: false,
                                    onExpand: {
                                        withAnimation {
                                            expandedItemID = item.id
                                        }
                                    },
                                    isSpace: marketType == 1
                                )
                            }
                        }
                    }
                    .animation(.easeInOut, value: expandedItemID)
                }
            }
        }
        .padding()
    }
}

struct SellItemCard: View {
    let item: SellItem
    let isExpanded: Bool
    let onExpand: () -> Void
    let isSpace: Bool
    @State private var selectedImage = 0
    
    var body: some View {
        VStack() {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: item.userIcon)
                        .resizable()
                        .frame(width: isExpanded ? 36 : 24, height: isExpanded ? 36 : 24)
                    Text(item.userName)
                        .font(isExpanded ? .title3.bold() : .subheadline.bold())
                }
                Spacer()
                Text(item.startTime, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(item.description)
                .font(isExpanded ? .body.weight(.medium) : .body)
                .lineLimit(isExpanded ? nil : 2)
                .truncationMode(.tail)
                .foregroundColor(Color.secondary)
            // Images with page dots
            TabView(selection: $selectedImage) {
                ForEach(item.images.indices, id: \ .self) { idx in
                    Image(systemName: item.images[idx])
                        .resizable()
                        .scaledToFit()
                        .frame(height: isExpanded ? 180 : 120)
                        .clipped()
                        .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: isExpanded ? 180 : 120)
            .background(Color.gray)
            .cornerRadius(20, antialiased: false)
            // Price info
            VStack {
                if isSpace {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Price: $\(String(format: "%.2f", item.basePrice))/hour")
                            .font(isExpanded ? .headline : .caption)
                    }
                    Button(action: {
                        // Contact or book action for space
                    }) {
                        Text("Book Now")
                            .font(isExpanded ? .title3 : .headline)
                            .padding(isExpanded ? 12 : 8)
                            .background(Color("AccentColor"))
                            .cornerRadius(8)
                    }
                    .foregroundColor(Color.white)
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Base: $\(String(format: "%.2f", item.basePrice))")
                            .font(isExpanded ? .headline : .caption)
                        Text("+ $\(String(format: "%.2f", item.increment)) per bid")
                            .font(isExpanded ? .subheadline : .caption2)
                            .foregroundColor(Color.secondary)
                    }
                    Button(action: {
                        // Offer price action
                    }) {
                        Text("Offer $\(String(format: "%.2f", item.currentPrice)) Now")
                            .font(isExpanded ? .title3 : .headline)
                            .padding(isExpanded ? 12 : 8)
                            .background(Color("AccentColor"))
                            .cornerRadius(8)
                    }
                    .foregroundColor(Color.white)
                }
            }
        }
        .padding(isExpanded ? 24 : 12)
        .background(Color(.systemBackground))
        .cornerRadius(isExpanded ? 20 : 12)
        .shadow(color: Color.black.opacity(isExpanded ? 0.12 : 0.05), radius: isExpanded ? 10 : 4, x: 0, y: 2)
        .scaleEffect(isExpanded ? 1.04 : 1.0)
        .animation(.easeInOut, value: isExpanded)
        .onTapGesture {
            onExpand()
        }
    }
}

#Preview {
    SellView()
}
