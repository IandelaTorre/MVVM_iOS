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
    
    var cancellables = Set<AnyCancellable>()
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        formValidation()
    }
    
    func formValidation() {
        $email.sink { value in
            print("Email: \(value)")
        }.store(in: &cancellables)
        
        $password.sink { value in
            print("Password: \(value)")
        }.store(in: &cancellables)
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
