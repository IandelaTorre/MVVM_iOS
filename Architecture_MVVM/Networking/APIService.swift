//
//  APIService.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 29/07/25.
//

import Alamofire

class ApiService {
    func login(user: String, password: String, time: Int, completion: @escaping (Result<String, Error>) -> Void) {
            let url = "https://basicapi-7xoy.onrender.com/api/v1/login/"
            let parameters: [String: Any] = [
                "user": user,
                "password": password,
                "time": time
            ]
            let headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseData { response in
                print("Código de estado:", response.response?.statusCode ?? 0)
                if let data = response.data,
                   let body = String(data: data, encoding: .utf8) {
                    print("Respuesta del servidor:", body)
                }
                print("Error:", response.error ?? "ninguno")
            }

        }
}

