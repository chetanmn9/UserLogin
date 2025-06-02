//
//  LoginRequest.swift
//  Login

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

// File: Models/LoginResponse.swift
struct LoginResponse: Codable {
    let token: String
}

