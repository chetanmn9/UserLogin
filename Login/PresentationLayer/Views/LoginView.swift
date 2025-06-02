//
//  ContentView.swift
//  Login

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case username
        case password
    }
    
    init() {
        let apiURL = Environment.apiBaseURL
        let service = AuthService(baseURL: apiURL)
        let repository = AuthRepositoryImpl(service: service)
        let useCase = LoginUseCase(repository: repository)
        _viewModel = StateObject(wrappedValue: LoginViewModel(loginUseCase: useCase))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 16) {
                        TextField("Username", text: $viewModel.username)
                            .autocapitalization(.none)
                            .focused($focusedField, equals: .username)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        SecureField("Password", text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 30)
                    
                    
                        Button(action: {
                            Task {
                                await viewModel.login()
                            }
                        }) {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                        }
                        .padding(.top, 20)
                        .disabled(!viewModel.isFormValid || viewModel.isLoading)
                        .opacity((!viewModel.isFormValid || viewModel.isLoading) ? 0.5 : 1.0)
                        .disabled(viewModel.isLoading)
                        .opacity(viewModel.isLoading ? 0.5 : 1.0)
                }
                .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                    HomeView()
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.isLoading)
                    
                    VStack {
                        Spacer()
                        
                        Text("Logging in...")
                            .font(.headline)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .animation(.easeInOut, value: viewModel.showToast)
                }
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                Text("Hi, Welcome Eve")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }.navigationTitle(Text("Home"))
        }
    }
}


#Preview {
    LoginView()
}
