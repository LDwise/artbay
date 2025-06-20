import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var progress: CGFloat = 0.0
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 32)
                // Header
                HStack {
                    Spacer()
                    Image(systemName: "paintbrush.pointed")
                        .font(.title)
                        .foregroundColor(Color("AccentColor"))
                    Text("ArtBay")
                        .font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
                // Card container
                VStack(spacing: 28) {
                    VStack(spacing: 10) {
                        Text("Sign in to continue")
                            .font(.title).bold()
                            .multilineTextAlignment(.center)
                        Text("New users will be automatically registered")
                            .font(.body)
                            .foregroundColor(Color.primary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    VStack(spacing: 18) {
                        SignInWithAppleButton(
                            onRequest: { request in
                                signIn(method: "Apple")
                            },
                            onCompletion: { result in
                                signIn(method: "apple")
                            }
                        )
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 48)
                        SignInButton(label: "Sign in with Google", icon: "g.circle.fill") {
                            signIn(method: "Google")
                        }
                        SignInButton(label: "Sign in with Microsoft", icon: "m.circle.fill") {
                            signIn(method: "Microsoft")
                        }
                        SignInButton(label: "Sign in with Facebook", icon: "f.circle.fill") {
                            signIn(method: "Facebook")
                        }
                    }
                    .padding(.top, 8)
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding(.top, 8)
                    Text("By signing in, you agree to our Terms and Conditions")
                        .font(.footnote)
                        .foregroundColor(Color.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color(.black).opacity(0.07), radius: 8, x: 0, y: 2)
                .padding(.horizontal, 24)
                Spacer()
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

struct SignInButton: View {
    let label: String
    let icon: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .foregroundColor(.primary)
            .cornerRadius(14)
            .shadow(color: Color(.black).opacity(0.04), radius: 2, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color("AccentColor").opacity(0.18), lineWidth: 1.2)
            )
        }
    }
}

#Preview {
    SignInView()
}
