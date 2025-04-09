//
//  LoginView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 09.04.25.
//

import SwiftUI
import AuthenticationServices // Required for Apple Sign In

struct LoginView: View {
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            // App Logo/Title
            Image(systemName: "music.note")
                .font(.system(size: 60))
                .padding(.bottom, 40)

            Text("Music App")
                .font(.largeTitle)
                .bold()

            // Apple Sign In Button
            SignInWithAppleButton(.signIn) { request in
                // Configure the request
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                // Handle completion
                switch result {
                case .success(let authResults):
                    print("Authorization successful: \(authResults)")
                    // Here you would typically:
                    // 1. Get the credential
                    // 2. Authenticate with your backend
                    // 3. Handle successful login
                case .failure(let error):
                    print("Authorization failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .padding(.horizontal, 40)

            // Loading indicator
            if isLoading {
                ProgressView()
                    .padding(.top, 20)
            }

            // Mock "Skip Login" for testing
            Button("Continue as Guest") {
                // Handle guest login
                print("Guest login selected")
            }
            .foregroundColor(.gray)
            .padding(.top, 20)
        }
        .padding()
    }
}

// Preview
#Preview {
    LoginView()
}
