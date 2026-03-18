//
//  HTTPClientTests.swift
//  fayTests
//
//  Created by Cassie Wallace on 3/18/26.
//

import Testing
import Foundation
@testable import fay

@Suite("HTTPClient")
struct HTTPClientTests {
    private let baseURL = URL(string: "https://node-api-for-candidates.onrender.com")!

    private func makeClient() -> HTTPClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return HTTPClient(session: session)
    }

    private func makeResponse(statusCode: Int, url: URL? = nil) -> HTTPURLResponse {
        HTTPURLResponse(
            url: url ?? baseURL,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    // MARK: - signIn

    @Test("signIn returns token on 200")
    func signIn_success_returnsToken() async throws {
        let client = makeClient()
        let expectedToken = "test-jwt-token"
        let responseData = try JSONEncoder().encode(["token": expectedToken])

        MockURLProtocol.requestHandler = { [makeResponse] _ in
            (makeResponse(200), responseData)
        }

        let token = try await client.signIn(username: "john", password: "12345")
        #expect(token == expectedToken)
    }

    @Test("signIn throws unauthorized on 401")
    func signIn_unauthorized_throwsError() async throws {
        let client = makeClient()

        MockURLProtocol.requestHandler = { [makeResponse] _ in
            (makeResponse(401), Data())
        }

        await #expect(throws: HTTPClientError.unauthorized) {
            try await client.signIn(username: "wrong", password: "wrong")
        }
    }

    // MARK: - fetchAppointments

    @Test("fetchAppointments decodes appointments on 200")
    func fetchAppointments_success_decodesAppointments() async throws {
        let client = makeClient()
        let json = """
        {
            "appointments": [
                {
                    "appointment_id": "abc123",
                    "patient_id": "1",
                    "provider_id": "100",
                    "status": "Scheduled",
                    "appointment_type": "Follow-up",
                    "start": "2025-11-08T17:00:00Z",
                    "end": "2025-11-08T18:00:00Z",
                    "duration_in_minutes": 60,
                    "recurrence_type": "Weekly"
                }
            ]
        }
        """
        let responseData = Data(json.utf8)

        MockURLProtocol.requestHandler = { [makeResponse] _ in
            (makeResponse(200), responseData)
        }

        let appointments = try await client.fetchAppointments(token: "valid-token")
        #expect(appointments.count == 1)
        #expect(appointments[0].id == "abc123")
        #expect(appointments[0].appointmentType == "Follow-up")
    }

    @Test("fetchAppointments throws unauthorized on 401")
    func fetchAppointments_unauthorized_throwsError() async throws {
        let client = makeClient()

        MockURLProtocol.requestHandler = { [makeResponse] _ in
            (makeResponse(401), Data())
        }

        await #expect(throws: HTTPClientError.unauthorized) {
            try await client.fetchAppointments(token: "expired-token")
        }
    }

    @Test("fetchAppointments throws DecodingError on malformed JSON")
    func fetchAppointments_malformedJSON_throwsDecodingError() async throws {
        let client = makeClient()
        let malformedData = Data(#"{"appointments": "not an array"}"#.utf8)

        MockURLProtocol.requestHandler = { [makeResponse] _ in
            (makeResponse(200), malformedData)
        }

        await #expect(throws: (any Error).self) {
            try await client.fetchAppointments(token: "valid-token")
        }
    }
}
