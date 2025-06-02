//
//  AuthRepositoryTests.swift
//  Login


import Foundation
import XCTest
@testable import Login

class MockAuthService: AuthService {
    var loginCalled = false
    var shouldReturnError = false
    var mockToken: String = "mocked_token"

    override func login(request: LoginRequest) async throws -> LoginResponse {
        loginCalled = true
        if shouldReturnError {
            throw NSError(domain: "MockAuthService", code: 1234, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return LoginResponse(token: mockToken)
    }
}

final class AuthRepositoryTests: XCTestCase {
    func testLoginSuccess() async throws {
        // Arrange
        let mockService = MockAuthService(baseURL: URL(string: "https://example.com")!)
        let repository = AuthRepositoryImpl(service: mockService)

        // Act
        let token = try await repository.login(email: "testuser", password: "testpass")

        // Assert
        XCTAssertEqual(token, "mocked_token")
        XCTAssertTrue(mockService.loginCalled)
    }

    func testLoginFailure() async throws {
        // Arrange
        let mockService = MockAuthService(baseURL: URL(string: "https://example.com")!)
        mockService.shouldReturnError = true
        let repository = AuthRepositoryImpl(service: mockService)

        // Act & Assert
        do {
            _ = try await repository.login(email: "wronguser", password: "wrongpass")
            XCTFail("Expected login to fail but succeeded")
        } catch {
            XCTAssertTrue(mockService.loginCalled)
            XCTAssertEqual((error as NSError).domain, "MockAuthService")
        }
    }
}
