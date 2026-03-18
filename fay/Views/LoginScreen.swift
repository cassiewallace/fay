//
//  LoginScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct LoginScreen: View {
    var onSignedIn: (String) -> Void

    @State private var viewModel = AuthViewModel()

    init(onSignedIn: @escaping (String) -> Void) {
        self.onSignedIn = onSignedIn
    }

    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case username, password
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Image("LoginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .ignoresSafeArea()

                loginCard
                    .frame(width: geometry.size.width)
            }
            .overlay(alignment: .topLeading) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 80)
                    .padding(.leading, Constants.xl)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var loginCard: some View {
        formSection
            .padding(.horizontal, Constants.xl)
            .padding(.vertical, Constants.xxl)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 24))
            .ignoresSafeArea(edges: .bottom)
    }

    private var formSection: some View {
        VStack(spacing: Constants.l) {
            if case .error(let message) = viewModel.state {
                errorBanner(message: message)
            }

            VStack(alignment: .leading, spacing: Constants.s) {
                Text(Copy.Login.usernameTitle)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.foreground.primary)
                TextField(Copy.Login.usernamePlaceholder, text: $username)
                    .textContentType(.username)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .onSubmit { focusedField = .password }
                    .padding(Constants.l)
                    .background(Color.background.card)
                    .clipShape(.rect(cornerRadius: Constants.l))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.l)
                            .strokeBorder(Color.border.default, lineWidth: 1)
                    )
                    .accessibilityLabel(Copy.Login.usernameTitle)
            }

            VStack(alignment: .leading, spacing: Constants.s) {
                Text(Copy.Login.passwordTitle)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.foreground.primary)
                SecureField(Copy.Login.passwordPlaceholder, text: $password)
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .onSubmit(attemptSignIn)
                    .padding(Constants.l)
                    .background(Color.background.card)
                    .clipShape(.rect(cornerRadius: Constants.l))
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.l)
                            .strokeBorder(Color.border.default, lineWidth: 1)
                    )
                    .accessibilityLabel(Copy.Login.passwordTitle)
            }

            FayButton(copy: Copy.Login.signInButton, action: attemptSignIn, isLoading: viewModel.state.isLoading)
                .disabled(username.isEmpty || password.isEmpty)
        }
    }

    private func errorBanner(message: String) -> some View {
        HStack(spacing: Constants.s) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: Constants.xs) {
                Text(Copy.Login.errorTitle)
                    .font(.subheadline.bold())
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(Constants.l)
        .background(Color.red.opacity(0.08))
        .clipShape(.rect(cornerRadius: Constants.m))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
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

// MARK: - Previews

#Preview {
    LoginScreen { _ in }
}
