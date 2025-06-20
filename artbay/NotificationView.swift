//
//  NotificationView.swift
//  artbay
//
//  Created by user on 20/6/2025.
//

import SwiftUI

// MARK: - Notification Data Models

// Enum for notification types
enum NotificationType {
    case wonArtwork(artTitle: String, price: Double, artist: String, auctionEnd: Date)
    case soldArtwork(artTitle: String, buyer: String, status: PaymentStatus)
    case rentedSpace(location: String, duration: String, notes: String?)
    case spaceRentedOut(location: String, renter: String, duration: String)
    case upcomingExhibition(title: String, date: Date, location: String)
}

// Enum for payment status
enum PaymentStatus: String {
    case waiting = "Waiting for Payment"
    case paid = "Payment Completed"
}

// Notification item model
struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let date: Date
}

// MARK: - Sample Data

let sampleNotifications: [NotificationItem] = [
    .init(type: .wonArtwork(artTitle: "Sunset Dream", price: 1200, artist: "Alice Lee", auctionEnd: Date()), date: Date()),
    .init(type: .soldArtwork(artTitle: "Blue Night", buyer: "John Doe", status: .waiting), date: Date()),
    .init(type: .rentedSpace(location: "Gallery Room 2", duration: "2025-07-01 to 2025-07-10", notes: "Please arrive 1 hour early for setup."), date: Date()),
    .init(type: .spaceRentedOut(location: "Studio Loft", renter: "Jane Smith", duration: "2025-08-01 to 2025-08-15"), date: Date()),
    .init(type: .upcomingExhibition(title: "Modern Art Expo", date: Date().addingTimeInterval(86400 * 5), location: "ArtBay Hall"), date: Date())
]

// MARK: - Main Notification View

struct NotificationView: View {
    // MARK: State
    @State private var selectedTab: ViewType = .list
    @State private var selectedDate: Date = Date()
    var notifications: [NotificationItem] = sampleNotifications

    // MARK: ViewType Enum
    enum ViewType: String, CaseIterable, Identifiable {
        case list = "List"
        case calendar = "Calendar"
        var id: String { rawValue }
    }

    // MARK: Helper - Group notifications by day
    private var notificationsByDay: [Date: [NotificationItem]] {
        Dictionary(grouping: notifications) { item in
            Calendar.current.startOfDay(for: item.date)
        }
    }

    // MARK: Date Range for Calendar
    private var calendarRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        let oneYearFuture = calendar.date(byAdding: .year, value: 1, to: now) ?? now
        return oneYearAgo...oneYearFuture
    }

    // MARK: Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Segmented control for switching views
                Picker("View", selection: $selectedTab) {
                    ForEach(ViewType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .top])

                // Main content
                if selectedTab == .list {
                    notificationListView
                } else {
                    calendarView
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }

    // MARK: - List View
    var notificationListView: some View {
        List {
            ForEach(notifications) { notification in
                NotificationRow(item: notification)
                    .listRowBackground(Color(.systemBackground))
            }
        }
        .listStyle(.insetGrouped)
        .accessibilityElement(children: .contain)
    }

    // MARK: - Calendar View
    @ViewBuilder
    var calendarView: some View {
        ScrollView {
        VStack(spacing: 0) {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                in: calendarRange,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .accentColor(Color("AccentColor"))
            .frame(maxHeight: 350)
            .padding(.horizontal)
            .padding(.top, 24)
            .padding(.bottom, 8)
            Divider()
                VStack(alignment: .leading, spacing: 12) {
                    let day = Calendar.current.startOfDay(for: selectedDate)
                    if let events = notificationsByDay[day], !events.isEmpty {
                        Section(header: Text(selectedDate, style: .date).font(.headline)) {
                            ForEach(events) { event in
                                NotificationRow(item: event)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(8)
                            }
                        }
                    } else {
                        Text("No notifications for this date.")
                            .foregroundColor(.secondary)
                            .padding(.top, 16)
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}

// MARK: - Notification Row View

struct NotificationRow: View {
    let item: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch item.type {
            case .wonArtwork(let artTitle, let price, let artist, let auctionEnd):
                VStack(alignment: .leading, spacing: 8) {
                    Text("You won the auction for \(artTitle)!")
                        .font(.title3).fontWeight(.semibold)
                        .accessibilityLabel("You won the auction for \(artTitle)")
                    Text("Artist: \(artist)")
                        .font(.body)
                    Text("Winning Price: $\(String(format: "%.2f", price))")
                        .font(.body)
                    Text("Auction Ended: \(auctionEnd.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Button(action: { /* Payment action */ }) {
                        Text("Pay Now")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .accessibilityLabel("Pay now for \(artTitle)")
                    }
                    .padding(.top, 4)
                }
            case .soldArtwork(let artTitle, let buyer, let status):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your artwork \(artTitle) was sold!")
                        .font(.title3).fontWeight(.semibold)
                        .accessibilityLabel("Your artwork \(artTitle) was sold")
                    Text("Buyer: \(buyer)")
                        .font(.body)
                    HStack(spacing: 8) {
                        Text("Status:")
                            .font(.body)
                        if status == .waiting {
                            ProgressView()
                                .accessibilityLabel("Waiting for payment")
                            Text(status.rawValue)
                                .foregroundColor(.orange)
                                .font(.body)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .accessibilityHidden(true)
                            Text(status.rawValue)
                                .foregroundColor(.green)
                                .font(.body)
                        }
                    }
                }
            case .rentedSpace(let location, let duration, let notes):
                VStack(alignment: .leading, spacing: 8) {
                    Text("You rented a space!")
                        .font(.title3).fontWeight(.semibold)
                        .accessibilityLabel("You rented a space at \(location)")
                    Text("Location: \(location)")
                        .font(.body)
                    Text("Duration: \(duration)")
                        .font(.body)
                    if let notes = notes {
                        Text("Notes: \(notes)")
                            .italic()
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            case .spaceRentedOut(let location, let renter, let duration):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your space at \(location) has been rented out!")
                        .font(.title3).fontWeight(.semibold)
                        .accessibilityLabel("Your space at \(location) has been rented out to \(renter)")
                    Text("Renter: \(renter)")
                        .font(.body)
                    Text("Duration: \(duration)")
                        .font(.body)
                }
            case .upcomingExhibition(let title, let date, let location):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Upcoming Exhibition: \(title)")
                        .font(.title3).fontWeight(.semibold)
                        .accessibilityLabel("Upcoming exhibition: \(title)")
                    Text("Date: \(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.body)
                    Text("Location: \(location)")
                        .font(.body)
                    Button(action: { /* Add to calendar */ }) {
                        Text("Add to Calendar")
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .accessibilityLabel("Add \(title) to calendar")
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(20)
        .accessibilityElement(children: .combine)
    }
}

// MARK: - DateComponents Helper

extension DateComponents {
    var date: Date? {
        Calendar.current.date(from: self)
    }
}

extension Date {
    var toDateComponents: DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: self)
    }
}

// MARK: - Preview

#Preview {
    NotificationView()
}
