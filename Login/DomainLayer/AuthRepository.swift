//
//  AuthRepository.swift
//  Login


protocol AuthRepository {
    func login(email: String, password: String) async throws -> String
}

class AuthRepositoryImpl: AuthRepository {
    private let service: AuthService

    init(service: AuthService) {
        self.service = service
    }

    func login(email: String, password: String) async throws -> String {
        let request = LoginRequest(email: email, password: password)
        let response = try await service.login(request: request)
        return response.token
    }
}
