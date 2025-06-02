//
//  LoginUseCase.swift
//  Login


class LoginUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> String {
        return try await repository.login(email: email, password: password)
    }
}
