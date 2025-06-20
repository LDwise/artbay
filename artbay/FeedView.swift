import SwiftUI
import Foundation

struct FeedView: View {
    @State private var posts: [Post] = Post.mockPosts
    @State private var allPosts: [Post] = Post.mockPosts // Store all posts for filtering
    @State private var searchText: String = ""
    @State private var isPresentingPostComposer: Bool = false
    
    private func filterPosts(with query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            posts = allPosts
        } else {
            let lowercasedQuery = query.lowercased()
            posts = allPosts.filter { post in
                post.author.lowercased().contains(lowercasedQuery) ||
                post.title.lowercased().contains(lowercasedQuery) ||
                post.text.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    Image(systemName: "bolt.horizontal.fill")
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                    Text("Feed")
                        .font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.top, 8)
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search posts...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .onChange(of: searchText) { filterPosts(with: searchText) }
                }
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                // Composer
                PostComposerView(isPresented: $isPresentingPostComposer)
                    .padding(.bottom, 2)
                // Feed posts
                ScrollView {
                    LazyVStack(spacing: 18) {
                        ForEach(posts) { post in
                            FeedPostCard(post: post)
                                .animation(.spring(), value: posts.count)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 100) // Add bottom padding for floating tab bar
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct FeedPostCard: View {
    let post: Post
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Circle()
                    .fill(Color("AccentColor"))
                    .frame(width: 44, height: 44)
                    .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.author)
                        .font(.headline)
                    Text(post.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding(.bottom, 2)
            Text(post.title)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity, alignment: .center)
            Text(post.text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let imageName = post.imageName {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.gray.opacity(0.3))
                    .cornerRadius(14)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
            }
            HStack(spacing: 32) {
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "heart")
                        .foregroundColor(Color("AccentColor"))
                    Text(String(post.likes))
                }
                HStack(spacing: 6) {
                    Image(systemName: "bubble.right")
                        .foregroundColor(Color("AccentColor"))
                    Text(String(post.comments))
                }
                HStack(spacing: 6) {
                    Image(systemName: "arrowshape.turn.up.right")
                        .foregroundColor(Color("AccentColor"))
                    Text("8")
                }
            }
            .padding(.top, 2)
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
            // Future: show detail or quick actions
        }
    }
}

struct Post: Identifiable {
    let id = UUID()
    let author: String
    let title: String
    let text: String
    let imageName: String?
    let timestamp: Date
    let likes: Int
    let comments: Int
    
    static let mockPosts: [Post] = [
        Post(author: "@ArtisticSoul", title: "Excited to Share My Latest Piece!", text: "Just uploaded my new painting titled 'Whispers of the Ocean.' Check it out and let me know what you think! #ArtBay #NewArt #Painting #Ocean #Art", imageName: nil, timestamp: Date(), likes: 12, comments: 5),
        Post(author: "@CreativeJane", title: "Join My Virtual Exhibition!", text: "I'm hosting a virtual exhibition this Saturday! Come see my latest works and ask me anything about my creative process. RSVP in the comments! #VirtualExhibition #Exhibition #ArtTalk", imageName: nil, timestamp: Date().addingTimeInterval(-3600), likes: 8, comments: 3),
        Post(author: "@ArtTrader99", title: "Art Trading Made Easy!", text: "Just completed my first art trade on ArtBay! The secure payment options made it so simple. Highly recommend! #ArtTrading #ArtTrade #SecurePayments", imageName: nil, timestamp: Date().addingTimeInterval(-7200), likes: 10, comments: 2),
        Post(author: "@SculptorSam", title: "Feedback Wanted!", text: "I just uploaded a new sculpture. I'd love your feedback! What do you think about the pricing? #ArtFeedback #Sculpture #ArtCommunity", imageName: nil, timestamp: Date().addingTimeInterval(-10800), likes: 6, comments: 4),
        Post(author: "@AbstractArtist", title: "Artist Spotlight: Jane Doe", text: "Check out Jane Doe's stunning abstract art! Her unique style is a must-see. Follow her for more amazing pieces! #ArtistSpotlight #AbstractArt #Follow", imageName: nil, timestamp: Date().addingTimeInterval(-14400), likes: 15, comments: 6),
        Post(author: "@ArtTipsGuru", title: "Tips for Art Uploads", text: "New to ArtBay? Here are some tips for uploading your artwork: Use high-quality images, write detailed descriptions, and tag your art! #ArtTips #ArtUpload #Tips", imageName: nil, timestamp: Date().addingTimeInterval(-18000), likes: 9, comments: 1),
        Post(author: "@ArtBayUpdates", title: "Community Update!", text: "We’ve added new filters to our search feature! Now you can find art by style, price range, and popularity. Happy searching! #ArtBayUpdates #Search #Updates", imageName: nil, timestamp: Date().addingTimeInterval(-21600), likes: 11, comments: 2),
        Post(author: "@HappyArtist", title: "Just Sold My First Piece!", text: "Thrilled to announce that my painting 'Sunset Dreams' has sold! Thank you to the buyer! #ArtSales #Sold #ArtSuccess", imageName: nil, timestamp: Date().addingTimeInterval(-25200), likes: 13, comments: 3),
        Post(author: "@CollabArtist", title: "Let's Connect!", text: "Looking for fellow artists to collaborate with! DM me if you're interested in working together on a project. #Collaboration #ArtistsConnect #Collab", imageName: nil, timestamp: Date().addingTimeInterval(-28800), likes: 7, comments: 2),
        Post(author: "@WatercolorWiz", title: "Upcoming Workshop Alert!", text: "Join me for a workshop on watercolor techniques next week! Limited spots available. Sign up now! #ArtWorkshop #Watercolor #Workshop", imageName: nil, timestamp: Date().addingTimeInterval(-32400), likes: 5, comments: 1),
        Post(author: "@VisionaryArtist", title: "Art Creation Process", text: "Check out my latest video on how I created my new piece! I used the Vision Pro feature to record the entire process. #ArtCreation #ArtVideo #Process", imageName: nil, timestamp: Date().addingTimeInterval(-36000), likes: 8, comments: 2),
        Post(author: "@ArtSeller", title: "New Art Listings!", text: "Just listed several new artworks for sale! Take a look and let me know if you have any questions. #NewArt #ArtForSale #NewListings", imageName: nil, timestamp: Date().addingTimeInterval(-39600), likes: 10, comments: 2),
        Post(author: "@CommunityVoice", title: "Community Feedback", text: "What features would you like to see on ArtBay? We value your input! #CommunityFeedback #UserInput #ArtBay", imageName: nil, timestamp: Date().addingTimeInterval(-43200), likes: 6, comments: 1),
        Post(author: "@ArtTrendWatcher", title: "Art Trends to Watch", text: "Here are some emerging art trends for 2025! What do you think will be the next big thing? #ArtTrends #Trends #ArtMarket", imageName: nil, timestamp: Date().addingTimeInterval(-46800), likes: 9, comments: 2),
        Post(author: "@LocalArtSupporter", title: "Support Local Artists!", text: "Check out these amazing local artists on ArtBay! Let's support our community! #SupportLocal #LocalArtists #CommunitySupport", imageName: nil, timestamp: Date().addingTimeInterval(-50400), likes: 14, comments: 4)
    ]
}

struct PostComposerView: View {
    @Binding var isPresented: Bool
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color("AccentColor"))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "person.fill").foregroundColor(.white))
            TextField("What's on your mind?", text: .constant(""))
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
                .background(Color(.systemGray6))
                .cornerRadius(18)
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    FeedView()
}
