//
//  LoginViewModel.swift
//  Login

import SwiftUI


class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var token: String?
    @Published var isLoggedIn = false
    @Published var showToast: Bool = false
    
    var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    @MainActor
    func login() async {
        isLoading = true
        errorMessage = nil
        isLoggedIn = false
        
        do {
            let token = try await loginUseCase.execute(email: username, password: password)
            self.token = token
            self.isLoggedIn = true
            self.showToast = true
        } catch {
            isLoggedIn = false 
            self.errorMessage = error.localizedDescription
            self.showToast = false
        }
        
        isLoading = false
    }
}
