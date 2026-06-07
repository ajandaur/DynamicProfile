//
//  NetworkService.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/6/26.
//

import Foundation

// MARK: - Response Wrappers

private struct UsersResponse: Decodable {
    let users: [User]
}

// MARK: - Protocol

protocol NetworkServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchConfig() async throws -> Config
}

// MARK: - Errors

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .invalidResponse:
            return "The server returned an unexpected response."
        case .httpError(let statusCode):
            return "Request failed with status code \(statusCode)."
        }
    }
}

// MARK: - Implementation

final class NetworkService: NetworkServiceProtocol {

    private let baseURL = "http://hinge-ue1-dev-cli-android-homework.s3-website-us-east-1.amazonaws.com"
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
    }

    func fetchUsers() async throws -> [User] {
        let response: UsersResponse = try await fetch(path: "/users")
        return response.users
    }

    func fetchConfig() async throws -> Config {
        try await fetch(path: "/config")
    }

    // MARK: - Private

    private func fetch<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }
}
