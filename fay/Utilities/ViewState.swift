//
//  ViewState.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

/// Represents the loading, content, and error states of a view that fetches data.
enum ViewState<T> {

    // MARK: - Cases

    case idle
    case loading
    case loaded(T)
    case error(String)

    // MARK: - Public

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var errorMessage: String? {
        if case .error(let message) = self { return message }
        return nil
    }

    var value: T? {
        if case .loaded(let value) = self { return value }
        return nil
    }
}

extension ViewState: Equatable where T: Equatable {}
