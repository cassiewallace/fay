//
//  LoginScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct LoginScreen: View {
    var client: any HTTPClientProtocol
    var onSignedIn: (String) -> Void

    @State private var viewModel: AuthViewModel

    init(client: any HTTPClientProtocol = HTTPClient.shared, onSignedIn: @escaping (String) -> Void) {
        self.client = client
        self.onSignedIn = onSignedIn
        _viewModel = State(initialValue: AuthViewModel(client: client))
    }

    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case username, password
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                formSection
            }
            .padding(.horizontal, 24)
            .padding(.top, 80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surface.primary.ignoresSafeArea())
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(Copy.Login.screenTitle)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(Copy.Login.screenSubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var formSection: some View {
        VStack(spacing: 16) {
            if let errorMessage = viewModel.errorMessage {
                errorBanner(message: errorMessage)
            }

            TextField(Copy.Login.emailPlaceholder, text: $username)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .username)
                .onSubmit { focusedField = .password }
                .padding()
                .background(Color.surface.card)
                .clipShape(.rect(cornerRadius: 12))
                .accessibilityLabel(Copy.Login.emailPlaceholder)

            SecureField(Copy.Login.passwordPlaceholder, text: $password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .onSubmit(attemptSignIn)
                .padding()
                .background(Color.surface.card)
                .clipShape(.rect(cornerRadius: 12))
                .accessibilityLabel(Copy.Login.passwordPlaceholder)

            signInButton
        }
    }

    private func errorBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(Copy.Login.errorTitle)
                    .font(.subheadline.bold())
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.red.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
    }

    private var signInButton: some View {
        Button(action: attemptSignIn) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(Copy.Login.signInButton)
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .disabled(viewModel.isLoading || username.isEmpty || password.isEmpty)
        .buttonStyle(PrimaryButtonStyle())
    }

    private func attemptSignIn() {
        focusedField = nil
        Task {
            if let token = await viewModel.signIn(username: username, password: password) {
                onSignedIn(token)
            }
        }
    }
}

// MARK: - Primary Button Style

private struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                Color.fill.accent
                    .opacity(configuration.isPressed ? 0.8 : 1)
            )
            .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Previews

#Preview("Default") {
    LoginScreen(client: MockHTTPClient()) { _ in }
}

#Preview("Loading") {
    let vm = AuthViewModel(client: MockHTTPClient())
    vm.isLoading = true
    return LoginScreen(client: MockHTTPClient(), onSignedIn: { _ in })
        .withViewModel(vm)
}

#Preview("Error") {
    let vm = AuthViewModel(client: MockHTTPClient())
    vm.errorMessage = Copy.Errors.unauthorized
    return LoginScreen(client: MockHTTPClient(), onSignedIn: { _ in })
        .withViewModel(vm)
}

// MARK: - Preview Helper

private extension LoginScreen {
    func withViewModel(_ vm: AuthViewModel) -> LoginScreen {
        let copy = self
        copy.viewModel = vm
        return copy
    }
}
