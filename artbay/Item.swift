//
//  Item.swift
//  artbay
//
//  Created by user on 17/6/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var itemDescription: String // Renamed from 'description'
    var category: String
    var basePrice: Double
    var priceIncrement: Double
    var imagePath: String? // Store image file path
    var timestamp: Date
    // Added fields for MarketView features
    var artist: String
    var popularity: Int
    var isAuction: Bool
    var currentPrice: Double
    
    init(title: String, itemDescription: String, category: String, basePrice: Double, priceIncrement: Double, imagePath: String?, timestamp: Date, artist: String, popularity: Int, isAuction: Bool, currentPrice: Double) {
        self.title = title
        self.itemDescription = itemDescription
        self.category = category
        self.basePrice = basePrice
        self.priceIncrement = priceIncrement
        self.imagePath = imagePath
        self.timestamp = timestamp
        self.artist = artist
        self.popularity = popularity
        self.isAuction = isAuction
        self.currentPrice = currentPrice
    }
    
    static let demoArtItems: [Item] = [
        Item(title: "Sunset Dream", itemDescription: "Sample art description for Sunset Dream", category: "Painting", basePrice: 100, priceIncrement: 10, imagePath: nil, timestamp: Date(), artist: "Alice", popularity: 120, isAuction: true, currentPrice: 120),
        Item(title: "Urban Jungle", itemDescription: "Sample art description for Urban Jungle", category: "Sculpture", basePrice: 110, priceIncrement: 11, imagePath: nil, timestamp: Date().addingTimeInterval(-3600), artist: "Bob", popularity: 80, isAuction: false, currentPrice: 110),
        Item(title: "Blue Night", itemDescription: "Sample art description for Blue Night", category: "Photography", basePrice: 120, priceIncrement: 12, imagePath: nil, timestamp: Date().addingTimeInterval(-7200), artist: "Charlie", popularity: 95, isAuction: true, currentPrice: 135),
        Item(title: "Abstract Flow", itemDescription: "Sample art description for Abstract Flow", category: "Digital", basePrice: 130, priceIncrement: 13, imagePath: nil, timestamp: Date().addingTimeInterval(-10800), artist: "Alice", popularity: 110, isAuction: false, currentPrice: 130),
        Item(title: "Golden Fields", itemDescription: "Sample art description for Golden Fields", category: "Other", basePrice: 140, priceIncrement: 14, imagePath: nil, timestamp: Date().addingTimeInterval(-14400), artist: "Bob", popularity: 60, isAuction: true, currentPrice: 154),
        Item(title: "Digital Mirage", itemDescription: "Sample art description for Digital Mirage", category: "Painting", basePrice: 150, priceIncrement: 15, imagePath: nil, timestamp: Date().addingTimeInterval(-18000), artist: "Charlie", popularity: 130, isAuction: false, currentPrice: 150),
        Item(title: "Silent Forest", itemDescription: "Sample art description for Silent Forest", category: "Sculpture", basePrice: 160, priceIncrement: 16, imagePath: nil, timestamp: Date().addingTimeInterval(-21600), artist: "Alice", popularity: 70, isAuction: true, currentPrice: 176),
        Item(title: "Red Horizon", itemDescription: "Sample art description for Red Horizon", category: "Photography", basePrice: 170, priceIncrement: 17, imagePath: nil, timestamp: Date().addingTimeInterval(-25200), artist: "Bob", popularity: 105, isAuction: false, currentPrice: 170),
        Item(title: "Ocean Whisper", itemDescription: "Sample art description for Ocean Whisper", category: "Digital", basePrice: 180, priceIncrement: 18, imagePath: nil, timestamp: Date().addingTimeInterval(-28800), artist: "Charlie", popularity: 90, isAuction: true, currentPrice: 198),
        Item(title: "City Lights", itemDescription: "Sample art description for City Lights", category: "Other", basePrice: 190, priceIncrement: 19, imagePath: nil, timestamp: Date().addingTimeInterval(-32400), artist: "Alice", popularity: 100, isAuction: false, currentPrice: 190),
        Item(title: "Pastel Sky", itemDescription: "Sample art description for Pastel Sky", category: "Painting", basePrice: 200, priceIncrement: 20, imagePath: nil, timestamp: Date().addingTimeInterval(-36000), artist: "Bob", popularity: 85, isAuction: true, currentPrice: 220),
        Item(title: "Emerald Path", itemDescription: "Sample art description for Emerald Path", category: "Sculpture", basePrice: 210, priceIncrement: 21, imagePath: nil, timestamp: Date().addingTimeInterval(-39600), artist: "Charlie", popularity: 75, isAuction: false, currentPrice: 210),
        Item(title: "Shadow Play", itemDescription: "Sample art description for Shadow Play", category: "Photography", basePrice: 220, priceIncrement: 22, imagePath: nil, timestamp: Date().addingTimeInterval(-43200), artist: "Alice", popularity: 140, isAuction: true, currentPrice: 242),
        Item(title: "Neon Muse", itemDescription: "Sample art description for Neon Muse", category: "Digital", basePrice: 230, priceIncrement: 23, imagePath: nil, timestamp: Date().addingTimeInterval(-46800), artist: "Bob", popularity: 65, isAuction: false, currentPrice: 230),
        Item(title: "Crystal Lake", itemDescription: "Sample art description for Crystal Lake", category: "Other", basePrice: 240, priceIncrement: 24, imagePath: nil, timestamp: Date().addingTimeInterval(-50400), artist: "Charlie", popularity: 115, isAuction: true, currentPrice: 264)
    ]

    static let demoSpaceItems: [Item] = [
        Item(title: "Gallery One", itemDescription: "Sample space description for Gallery One", category: "Space - Gallery", basePrice: 200, priceIncrement: 0, imagePath: nil, timestamp: Date(), artist: "VenueA", popularity: 50, isAuction: false, currentPrice: 200),
        Item(title: "Cafe Latte Wall", itemDescription: "Sample space description for Cafe Latte Wall", category: "Space - Cafe Wall", basePrice: 215, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-7200), artist: "VenueB", popularity: 40, isAuction: false, currentPrice: 215),
        Item(title: "Pop-up Central", itemDescription: "Sample space description for Pop-up Central", category: "Space - Pop-up", basePrice: 230, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-14400), artist: "VenueC", popularity: 60, isAuction: false, currentPrice: 230),
        Item(title: "Riverside Park", itemDescription: "Sample space description for Riverside Park", category: "Space - Outdoor", basePrice: 245, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-21600), artist: "VenueA", popularity: 55, isAuction: false, currentPrice: 245),
        Item(title: "Art Hub Gallery", itemDescription: "Sample space description for Art Hub Gallery", category: "Space - Gallery", basePrice: 260, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-28800), artist: "VenueB", popularity: 45, isAuction: false, currentPrice: 260),
        Item(title: "Urban Loft", itemDescription: "Sample space description for Urban Loft", category: "Space - Other", basePrice: 275, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-36000), artist: "VenueC", popularity: 35, isAuction: false, currentPrice: 275),
        Item(title: "Community Hall", itemDescription: "Sample space description for Community Hall", category: "Space - Other", basePrice: 290, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-43200), artist: "VenueA", popularity: 30, isAuction: false, currentPrice: 290),
        Item(title: "Seaside Wall", itemDescription: "Sample space description for Seaside Wall", category: "Space - Cafe Wall", basePrice: 305, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-50400), artist: "VenueB", popularity: 25, isAuction: false, currentPrice: 305),
        Item(title: "Market Booth", itemDescription: "Sample space description for Market Booth", category: "Space - Pop-up", basePrice: 320, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-57600), artist: "VenueC", popularity: 20, isAuction: false, currentPrice: 320),
        Item(title: "Hotel Lobby", itemDescription: "Sample space description for Hotel Lobby", category: "Space - Other", basePrice: 335, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-64800), artist: "VenueA", popularity: 15, isAuction: false, currentPrice: 335),
        Item(title: "Library Atrium", itemDescription: "Sample space description for Library Atrium", category: "Space - Other", basePrice: 350, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-72000), artist: "VenueB", popularity: 10, isAuction: false, currentPrice: 350),
        Item(title: "Rooftop Venue", itemDescription: "Sample space description for Rooftop Venue", category: "Space - Outdoor", basePrice: 365, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-79200), artist: "VenueC", popularity: 5, isAuction: false, currentPrice: 365),
        Item(title: "Warehouse Studio", itemDescription: "Sample space description for Warehouse Studio", category: "Space - Other", basePrice: 380, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-86400), artist: "VenueA", popularity: 3, isAuction: false, currentPrice: 380),
        Item(title: "Bookstore Nook", itemDescription: "Sample space description for Bookstore Nook", category: "Space - Other", basePrice: 395, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-93600), artist: "VenueB", popularity: 2, isAuction: false, currentPrice: 395),
        Item(title: "Conference Room", itemDescription: "Sample space description for Conference Room", category: "Space - Other", basePrice: 410, priceIncrement: 0, imagePath: nil, timestamp: Date().addingTimeInterval(-100800), artist: "VenueC", popularity: 1, isAuction: false, currentPrice: 410)
    ]
}
