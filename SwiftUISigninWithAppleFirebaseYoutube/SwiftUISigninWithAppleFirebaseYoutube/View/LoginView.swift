//
//  LoginView.swift
//  SwiftUISigninWithAppleFirebaseYoutube
//
//  Created by NextDay Sotware Solution on 02/09/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit


struct LoginView: View {
    ///View Properties
    // Unhashed nonce.
    @State private var currentNonce: String?
    @State private var errorMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var isLoading: Bool = false
    @Environment(\.colorScheme) private var scheme
    ///User Log Status
    @AppStorage("logStatus") private var logStatus: Bool = false
    var body: some View {
        ZStack(alignment: .bottom, content: {
            GeometryReader(content: { geometry in
                let size = geometry.size
                Image(.light3)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -60)
                    .frame(width: size.width, height: size.height)
            })
        })
        ///Gradient Masking At Bottom
        .mask {
            Rectangle()
                .fill(
                    .linearGradient(colors: [
                        .white,
                        .white,
                        .white,
                        .white,
                        .white.opacity(0.9),
                        .white.opacity(0.6),
                        .white.opacity(0.2),
                        .clear,
                        .clear
                    
                    ], startPoint: .top, endPoint: .bottom)
                )
        }
        .ignoresSafeArea()
        ///Sign in with apple
        VStack(alignment: .leading) {
            Text("Sign in to start your \nlearning experience")
                .font(.title.bold())
            SignInWithAppleButton(.signIn) { request in
                ///Your Preferences
                let nonce = randomNonceString()
                currentNonce = nonce
                request.nonce = sha256(nonce)
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { (result) in
                switch result {
                case .success(let authorization):
                    loginWithFirebase(authorization)
                case .failure(let error):
                    showError(error.localizedDescription)
                }
            }
            .overlay(content: {
                ZStack {
                   Capsule()
                    HStack {
                        Image(systemName: "apple.logo")
                            .foregroundStyle(.inverse)
                        Text("Sign in with apple")
                            .foregroundStyle(.inverse)
                    }
                    .foregroundStyle(scheme == .dark ? .white : .black)
                }
                .allowsHitTesting(false)
            })
            .frame(height: 45)
            .clipShape(.capsule)
            .padding(.top, 10)
            
            ///Other Sign in Options
            Button {
                
            } label: {
                Text("Other Sign in Options")
                    .foregroundStyle(Color.primary)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        Capsule()
                            .stroke(Color.primary, lineWidth: 0.5)
                    )
                    .contentShape(.capsule)
                    
            }

        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .alert(errorMessage, isPresented: $showAlert, actions: {
            
        })
        .overlay {
            if isLoading {
                LoadingScreen()
            }
        }
    }
    ///Loading Screen
    @ViewBuilder
    func LoadingScreen() -> some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
            ProgressView()
                .frame(width: 45, height: 45)
                .background(.background, in: .rect(cornerRadius: 5))
        }
    }
    ///Presenting Errors
    func showError(_ message: String) {
        errorMessage = message
        showAlert.toggle()
        isLoading = false
    }
    ///Login with firebase
    func loginWithFirebase(_ authorization: ASAuthorization) {
        ///Showing Loading Screen Until the process Complete
        isLoading = true
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                showError("Cannot process your request.")
                return
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                showError("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                showError("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    showError(error?.localizedDescription ?? "")
                    return
                }
                // User is signed in to Firebase with Apple.
                ///Pushing user to home screen
                logStatus = true
                isLoading = false
            }
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
        
}

#Preview {
    ContentView()
}
