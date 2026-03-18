//
//  APIConstants.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

/// API configuration.
enum APIConstants {

    // MARK: - Public

    static let baseURL = URL(string: "https://node-api-for-candidates.onrender.com")!
    static let signInPath = "signin"
    static let appointmentsPath = "appointments"
    /// Demo credentials from API documentation.
    static let demoUsername = "john"
    static let demoPassword = "12345"
}
