//
//  LoginViewModel.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var isEnabled = false
    @Published var showLoading = false
    @Published var userModel: User?
    @Published var errorMessage: String?

    private let apiService = ApiService()
    
    var cancellables = Set<AnyCancellable>()
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        formValidation()
    }
    
    func login(user: String, password: String, time: Int) {
        DispatchQueue.main.async { self.showLoading = true }

        apiService.login(user: user, password: password, time: time) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (payload, tokenHeader)):
                let token = tokenHeader ?? ""  // tu API no manda token en body
                let appUser = User(name: payload.name, token: token, sessionStart: Date())
                DispatchQueue.main.async {
                    self.errorMessage = nil
                    self.userModel = appUser      // ⬅️ dispara tu sink
                    self.showLoading = false
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.userModel = nil
                    self.showLoading = false
                }
            }
        }
    }

    
    func formValidation() {
        Publishers.CombineLatest($email, $password)
            .map { $0.count > 5 && $1.count > 5 }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: self)
            .store(in: &cancellables)
    }
    
    @MainActor
        func userLogin(withEmail email: String, password: String) async {
            errorMessage = nil
            showLoading = true
            defer { showLoading = false }
            do {
                userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as BackendError {
                errorMessage = error.rawValue
            } catch {
                errorMessage = error.localizedDescription
            }
        }
}
