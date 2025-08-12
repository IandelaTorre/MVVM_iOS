//
//  APIClient.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import Foundation

enum BackendError: String, Error {
    case invalidEmail = "Comprueba el email"
    case invalidPassword = "Comprueba tu password"
}

final class APIClient {
    func login(withEmail email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 2)
        return try simulateBackendLogic(email: email, password: password)
    }
}

func simulateBackendLogic(email: String, password: String) throws -> User {
    guard email == "admin@mailinator.com" else {
        print("El usuario es incorrecto")
        throw BackendError.invalidEmail
    }
    guard password == "123456789" else {
        print("La contraseña no es 123456789")
        throw BackendError.invalidPassword
    }
    print("success")
    return .init(name: "IAN", token: "token_1234567890", sessionStart: .now)
}
