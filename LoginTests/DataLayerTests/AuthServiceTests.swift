//
//  AuthServiceTests.swift
//  Login

import XCTest
@testable import Login

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        return (mockData ?? Data(), mockResponse ?? URLResponse())
    }
}

final class AuthServiceTests: XCTestCase {
    
    func testLoginSuccess() async throws {
        // Arrange
        let expectedToken = "mocked_token"
        let loginResponse = LoginResponse(token: expectedToken)
        let mockData = try JSONEncoder().encode(loginResponse)

        let mockSession = MockURLSession()
        mockSession.mockData = mockData
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com/login")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let authService = AuthService(
            baseURL: URL(string: "https://example.com")!,
            session: mockSession
        )

        let loginRequest = LoginRequest(email: "testuser", password: "testpass")

        // Act
        let response = try await authService.login(request: loginRequest)

        // Assert
        XCTAssertEqual(response.token, expectedToken)
    }

    func testLoginFailure_InvalidCredentials() async throws {
        // Arrange
        let mockSession = MockURLSession()
        mockSession.mockData = Data()
        mockSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://example.com/login")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )

        let authService = AuthService(
            baseURL: URL(string: "https://example.com")!,
            session: mockSession
        )

        let loginRequest = LoginRequest(email: "wrong", password: "wrong")

        // Act & Assert
        do {
            _ = try await authService.login(request: loginRequest)
            XCTFail("Expected to throw error but succeeded")
        } catch {
            XCTAssertEqual((error as NSError).domain, "AuthService")
            XCTAssertEqual((error as NSError).code, 401)
        }
    }
}


