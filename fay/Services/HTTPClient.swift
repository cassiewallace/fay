//
//  HTTPClient.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

enum HTTPClientError: Error, LocalizedError {
    case unauthorized
    case invalidResponse
    case serverError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return Copy.Errors.unauthorized
        case .invalidResponse:
            return Copy.Errors.invalidResponse
        case .serverError(let code):
            return Copy.Errors.serverError(code: code)
        }
    }
}

struct HTTPClient {
    static let shared = HTTPClient()

    private let baseURL = APIConstants.baseURL
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func signIn(username: String, password: String) async throws -> String {
        let url = baseURL.appendingPathComponent(APIConstants.signInPath)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["username": username, "password": password])

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return tokenResponse.token
        case 401:
            throw HTTPClientError.unauthorized
        default:
            throw HTTPClientError.serverError(statusCode: httpResponse.statusCode)
        }
    }

    func fetchAppointments(token: String) async throws -> [Appointment] {
        let url = baseURL.appendingPathComponent(APIConstants.appointmentsPath)
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let appointmentResponse = try decoder.decode(AppointmentResponse.self, from: data)
            return appointmentResponse.appointments
        case 401:
            throw HTTPClientError.unauthorized
        default:
            throw HTTPClientError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}

// MARK: - Private Response Types

private struct TokenResponse: Decodable {
    let token: String
}
