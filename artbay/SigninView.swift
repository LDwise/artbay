import SwiftUI
import AuthenticationServices

struct SignInMethod {
    let name: String
    let icon: String?
}

struct SignInView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var progress: CGFloat = 0.0
    
    private let signInMethods: [SignInMethod] = [
        SignInMethod(name: "Apple", icon: nil),
        SignInMethod(name: "Google", icon: "g.circle.fill"),
        SignInMethod(name: "Microsoft", icon: "m.circle.fill"),
        SignInMethod(name: "Facebook", icon: "f.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    Image("AppIconImage")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 100)
                    Text("ArtBay")
                        .font(.largeTitle).bold()
                }
                // Card container
                VStack(spacing: 28) {
                    VStack(spacing: 10) {
                        Text("Sign in to continue")
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                        Text("New users will be automatically registered")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.secondary)
                    }
                    VStack(spacing: 20) {
                        ForEach(signInMethods, id: \.name) { method in
                            if method.name == "Apple" {
                                SignInWithAppleButton(
                                    onRequest: { _ in
                                        signIn(method: method.name)
                                    },
                                    onCompletion: { _ in
                                        signIn(method: method.name)
                                    }
                                )
                                .frame(height: 48)
                            } else {
                                Button(action: { signIn(method: method.name) }) {
                                    HStack {
                                        if let icon = method.icon {
                                            Image(systemName: icon)
                                                .font(.title2)
                                        }
                                        Text("Sign in with \(method.name)")
                                            .multilineTextAlignment(.center)
                                            .font(.headline)
                                            .foregroundColor(Color.primary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                    Text("By signing in, you agree to our Terms and Conditions")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.secondary)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.primary.opacity(0.07), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 24)
            }
        }
    }

    private func signIn(method: String) {
        progress = 0.0

        // Animate progress bar from 0 to 1 over 0.7 seconds
        withAnimation(.linear(duration: 0.7)) {
            progress = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                viewModel.state = .signedIn
            }
        }
    }
}

#Preview {
    SignInView()
}
