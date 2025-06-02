//
//  LoginTests.swift
//  LoginTests


import XCTest
import Testing
@testable import Login

final class LoginViewModelTests: XCTestCase {
    
    class MockAuthRepository: AuthRepository {
        var shouldReturnError = false
        func login(email: String, password: String) async throws -> String {
            if shouldReturnError {
                throw NSError(domain: "MockAuthRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])
            }
            return "mock_token"
        }
    }
    
    func testSuccessfulLogin() async throws {
        let mockRepository = MockAuthRepository()
        let useCase = LoginUseCase(repository: mockRepository)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        
        viewModel.username = "testuser"
        viewModel.password = "password"
        
        await viewModel.login()
        
        XCTAssertEqual(viewModel.token, "mock_token")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testFailedLogin() async throws {
        let mockRepository = MockAuthRepository()
        mockRepository.shouldReturnError = true
        let useCase = LoginUseCase(repository: mockRepository)
        let viewModel = LoginViewModel(loginUseCase: useCase)
        
        viewModel.username = "wronguser"
        viewModel.password = "wrongpassword"
        
        await viewModel.login()
        
        XCTAssertNil(viewModel.token)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}

