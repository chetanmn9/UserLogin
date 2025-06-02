//
//  Environment.swift
//  Login


import Foundation

enum Environment {
    enum AppEnvironment: String {
        case dev = "DEV"
        case test = "TEST"
        case prod = "PROD"
    }

    static var current: AppEnvironment {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "ENVIRONMENT") as? String,
              let environment = AppEnvironment(rawValue: value.uppercased()) else {
            fatalError("ENVIRONMENT not set correctly in plist")
        }
        return environment
    }

    static var apiBaseURL: URL {
        let key: String
        switch current {
        case .dev: key = "API_BASE_URL_DEV"
        case .test: key = "API_BASE_URL_TEST"
        case .prod: key = "API_BASE_URL_PROD"
        }

        guard let urlString = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              let url = URL(string: urlString) else {
            fatalError("\(key) must be set in Info.plist")
        }

        return url
    }
}
