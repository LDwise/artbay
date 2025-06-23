//
//  ProfileView.swift
//  artbay
//
//  Created by user on 20/6/2025.
//

import SwiftUI

struct Exhibition: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let dateRange: String
}

struct ProfileHeaderView: View {
    let username: String
    let bio: String
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.accentColor)
                .padding(.top, 12)
            Text(username)
                .font(.title2)
                .fontWeight(.bold)
            Text(bio)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            HStack(spacing: 16) {
                Button("Edit Profile") {}
                    .buttonStyle(.borderedProminent)
                Button("Logout") {}
                    .buttonStyle(.bordered)
            }
            HStack(spacing: 40) {
                VStack {
                    Text("12")
                        .font(.headline)
                    Text("Artworks")
                        .font(.caption)
                }
                VStack {
                    Text("340")
                        .font(.headline)
                    Text("Followers")
                        .font(.caption)
                }
                VStack {
                    Text("180")
                        .font(.headline)
                    Text("Following")
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

private struct VirtualExhibitionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Virtual Exhibition")
                .font(.title3)
                .fontWeight(.semibold)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 180)
                .overlay(
                    Text("Vision Pro Exhibition Space\n(Coming Soon)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

private struct ExhibitionCalendarView: View {
    let exhibitions: [Exhibition]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exhibition Calendar")
                .font(.title3)
                .fontWeight(.semibold)
            ScrollView(.horizontal, showsIndicators: true) {
                HStack() {
                    ForEach(exhibitions) { exhibition in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(exhibition.title)
                                .font(.headline)
                            Text(exhibition.location)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text(exhibition.dateRange)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.accentColor.opacity(0.08)))
                        .frame(width: 180)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

private struct ArtworksGridView: View {
    let artworks: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("My Artworks")
                .font(.title3)
                .fontWeight(.semibold)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(artworks, id: \.self) { art in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(height: 100)
                        .overlay(
                            Text(art)
                                .foregroundColor(.accentColor)
                        )
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

private struct DashboardAnalyticsView: View {
    let views: Int
    let likes: Int
    let sales: Int
    var body: some View {
        VStack(spacing: 16) {
            Text("Dashboard Analytics")
                .font(.title3)
                .fontWeight(.semibold)
            HStack(spacing: 40) {
                VStack {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.blue)
                    Text("\(views)")
                        .font(.headline)
                    Text("Views")
                        .font(.caption)
                }
                VStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                    Text("\(likes)")
                        .font(.headline)
                    Text("Likes")
                        .font(.caption)
                }
                VStack {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.green)
                    Text("\(sales)")
                        .font(.headline)
                    Text("Sales")
                        .font(.caption)
                }
            }
            VStack(alignment: .leading) {
                Text("Performance Overview")
                    .font(.headline)
                HStack(alignment: .bottom, spacing: 24) {
                    VStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.blue)
                            .frame(width: 24, height: CGFloat(views) / 30)
                        Text("Views")
                            .font(.caption2)
                    }
                    VStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.pink)
                            .frame(width: 24, height: CGFloat(likes) / 10)
                        Text("Likes")
                            .font(.caption2)
                    }
                    VStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green)
                            .frame(width: 24, height: CGFloat(sales) * 2)
                        Text("Sales")
                            .font(.caption2)
                    }
                }
                .frame(height: 120)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

struct PortfolioItem: Identifiable {
    let id = UUID()
    let type: PortfolioType
    let title: String
    let url: String
}
enum PortfolioType {
    case image, video, website
}

private struct PortfolioSectionView: View {
    let items: [PortfolioItem]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Public Portfolio")
                .font(.title3)
                .fontWeight(.semibold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { item in
                        switch item.type {
                        case .image:
                            VStack {
                                AsyncImage(url: URL(string: item.url)) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 120, height: 120)
                                .clipped()
                                Text(item.title).font(.caption)
                            }
                        case .video:
                            VStack {
                                Image(systemName: "video.fill")
                                    .resizable()
                                    .frame(width: 120, height: 80)
                                    .foregroundColor(.accentColor)
                                Text(item.title).font(.caption)
                            }
                        case .website:
                            Link(destination: URL(string: item.url)!) {
                                VStack {
                                    Image(systemName: "globe")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.accentColor)
                                    Text(item.title).font(.caption)
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.accentColor.opacity(0.08))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

private struct RecentViewersView: View {
    let viewers: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Viewers")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewers, id: \.self) { viewer in
                        VStack {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.accentColor)
                            Text(viewer).font(.caption)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

private struct SettingsSupportView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.title3)
                .fontWeight(.semibold)
            Toggle(isOn: $isDarkMode) {
                HStack {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                    Text(isDarkMode ? "Dark Mode" : "Light Mode")
                }
            }
            .onChange(of: isDarkMode) { oldValue, newValue in
                // Fix deprecated onChange and windows usage
                // UIApplication.shared.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
            }
            Button(action: {}) {
                HStack {
                    Image(systemName: "gearshape")
                    Text("Account Settings")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(.plain)
            Button(action: {}) {
                HStack {
                    Image(systemName: "bell")
                    Text("Notification Preferences")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            .buttonStyle(.plain)
            Divider()
            Text("Official Support")
                .font(.headline)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.accentColor)
                Text("support@artbay.example.com")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.accentColor)
                Text("www.artbay.exmaple.com/support")
                    .font(.body)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.black).opacity(0.07), radius: 6, x: 0, y: 2)
    }
}

struct ProfileView: View {
    // Dummy user data
    let username = "ArtLover123"
    let bio = "Digital artist & collector. Exploring the world of art in AR."
    let artworks = ["art1", "art2", "art3", "art4", "art5", "art6"] // Placeholder artwork names
    // Sample exhibitions
    let exhibitions = [
        Exhibition(title: "Dreamscapes", location: "MoMA, NY", dateRange: "Jun 10 - Jul 10, 2025"),
        Exhibition(title: "Visions in Color", location: "Tate Modern, London", dateRange: "Jul 20 - Aug 15, 2025"),
        Exhibition(title: "ARt in Space", location: "Louvre, Paris", dateRange: "Sep 1 - Sep 30, 2025")
    ]
    // Dashboard analytics data
    let views = 2340
    let likes = 1120
    let sales = 58
    let portfolioItems = [
        PortfolioItem(type: .image, title: "Sunset", url: "https://placehold.co/120x120"),
        PortfolioItem(type: .video, title: "Art Process", url: "https://video.example.com/art-process"),
        PortfolioItem(type: .website, title: "My Website", url: "https://artlover123.com")
    ]
    let recentViewers = ["Alice", "Bob", "Charlie", "Dana"]
    @State private var selectedSegment = 0
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .font(.title)
                            .foregroundColor(Color("AccentColor"))
                        Text("Profile")
                            .font(.largeTitle).bold()
                        Spacer()
                    }
                    .padding(.top, 8)
                    // Segment Control
                    Picker("View", selection: $selectedSegment) {
                        Text("Public").tag(0)
                        Text("Dashboard").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    // Content
                    if selectedSegment == 0 {
                        ProfileHeaderView(username: username, bio: bio)
                        VirtualExhibitionView()
                        PortfolioSectionView(items: portfolioItems)
                        ExhibitionCalendarView(exhibitions: exhibitions)
                        ArtworksGridView(artworks: artworks)
                    } else {
                        DashboardAnalyticsView(views: views, likes: likes, sales: sales)
                        RecentViewersView(viewers: recentViewers)
                    }
                    SettingsSupportView()
                    Spacer(minLength: 32)
                }
                .padding(.top, 8)
            }
            .padding([.horizontal, .bottom])
        }
    }
}

#Preview {
    ProfileView()
}
