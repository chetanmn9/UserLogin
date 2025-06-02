//
//  AuthService.swift
//  Login

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}


class AuthService {
    var baseURL: URL
    var session: URLSessionProtocol

    init(baseURL: URL, session: URLSessionProtocol = URLSession.shared) {
            self.baseURL = baseURL
            self.session = session
        }
    
    private var defaultHeaders: [String: String] {
        var headers = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String, !apiKey.isEmpty {
            headers["x-api-key"] = "\(apiKey)"
        }
        return headers
    }

    func login(request: LoginRequest) async throws -> LoginResponse {
        let loginURL = baseURL.appendingPathComponent("login")
        var urlRequest = URLRequest(url: loginURL)
        urlRequest.httpMethod = "POST"

        for (key, value) in defaultHeaders {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "AuthService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials or bad response"])
        }

        return try JSONDecoder().decode(LoginResponse.self, from: data)
    }
}
