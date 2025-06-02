//
//  LoginUseCaseTests.swift
//  Login


import Foundation
import XCTest
@testable import Login

class MockAuthRepository: AuthRepository {
    var shouldReturnError = false
    var mockToken = "mocked_token"
    var loginCalled = false

    func login(email: String, password: String) async throws -> String {
        loginCalled = true
        if shouldReturnError {
            throw NSError(domain: "MockAuthRepository", code: 5678, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return mockToken
    }
}

final class LoginUseCaseTests: XCTestCase {
    func testExecuteSuccess() async throws {
        // Arrange
        let mockRepository = MockAuthRepository()
        let useCase = LoginUseCase(repository: mockRepository)

        // Act
        let token = try await useCase.execute(email: "testuser", password: "testpass")

        // Assert
        XCTAssertEqual(token, "mocked_token")
        XCTAssertTrue(mockRepository.loginCalled)
    }

    func testExecuteFailure() async throws {
        // Arrange
        let mockRepository = MockAuthRepository()
        mockRepository.shouldReturnError = true
        let useCase = LoginUseCase(repository: mockRepository)

        // Act & Assert
        do {
            _ = try await useCase.execute(email: "wronguser", password: "wrongpass")
            XCTFail("Expected execute to fail but succeeded")
        } catch {
            XCTAssertTrue(mockRepository.loginCalled)
            XCTAssertEqual((error as NSError).domain, "MockAuthRepository")
        }
    }
}
