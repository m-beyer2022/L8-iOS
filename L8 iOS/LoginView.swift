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
    var onLoginComplete: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // App Logo/Title
            Image(systemName: "music.note")
                .font(.system(size: 60))
                .padding(.bottom, 40)

            Text("Music App")
                .font(.largeTitle)
                .bold()

            // Apple Sign In Button (mocked)
            SignInWithAppleButton(.signIn) { _ in } onCompletion: { _ in
                handleLogin()
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .padding(.horizontal, 40)

            // Guest login button
            Button("Continue as Guest") {
                handleLogin()
            }
            .foregroundColor(.gray)
            .padding(.top, 20)

            // Loading indicator
            if isLoading {
                ProgressView()
                    .padding(.top, 20)
            }
        }
        .padding()
    }

    private func handleLogin() {
        isLoading = true
        // Simulate brief network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            onLoginComplete()
        }
    }
}

// Preview
#Preview {
    LoginView(onLoginComplete: {})
}  
