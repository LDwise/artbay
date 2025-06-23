//
//  artbayApp.swift
//  artbay
//  https://github.com/ldwise/artbay
//  Created by user on 17/6/2025.
//

import SwiftUI
import SwiftData

enum AppState {
    case signedIn
    case signedOut
}

class AppViewModel: ObservableObject {
    @Published var state: AppState

    init() {
        // Default to signed out; in real app, check persistent auth state here
        self.state = .signedOut
    }
}

@main
struct artbayApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            switch viewModel.state {
            case .signedIn:
                ContentView()
                    .environmentObject(viewModel)
            case .signedOut:
                SignInView()
                    .environmentObject(viewModel)
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
