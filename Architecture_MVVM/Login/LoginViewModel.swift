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
    
    var cancellables = Set<AnyCancellable>()
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        formValidation()
    }
    
    func formValidation() {
        Publishers.CombineLatest($email, $password)
            .filter { email, password in
                return email.count > 5 && password.count > 5
            }
            .sink { value in
                self.isEnabled = true
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(withEmail email: String, password: String) {
        Task {
            do {
                let userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
