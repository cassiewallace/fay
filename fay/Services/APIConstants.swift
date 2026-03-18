//
//  APIConstants.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

/// API configuration.
enum APIConstants {
    static let baseURL = URL(string: "https://node-api-for-candidates.onrender.com")!
    static let signInPath = "signin"
    static let appointmentsPath = "appointments"
    /// Demo credentials from API documentation (used by MockHTTPClient).
    static let demoUsername = "john"
    static let demoPassword = "12345"
}
