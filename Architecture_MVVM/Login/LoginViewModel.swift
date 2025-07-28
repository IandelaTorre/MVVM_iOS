//
//  LoginViewModel.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import Foundation

class LoginViewModel {
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
