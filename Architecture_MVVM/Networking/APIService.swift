//
//  APIService.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 29/07/25.
//

import Foundation
import Alamofire

private let iso8601WithFractional: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
}()

private let iso8601NoFractional: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime]
    return f
}()

class ApiService {
    func login(user: String,
               password: String,
               time: Int,
               completion: @escaping (Result<(LoginResponse, String?), Error>) -> Void) {

        let url = "https://basicapi-7xoy.onrender.com/api/v1/login/"
        let parameters: [String: Any] = ["user": user, "password": password, "time": time]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        let decoder = JSONDecoder()
        // ⚠️ Estrategia de fechas flexible (con y sin milisegundos)
        decoder.dateDecodingStrategy = .custom { dec in
            let c = try dec.singleValueContainer()
            let s = try c.decode(String.self)
            if let d = iso8601WithFractional.date(from: s) { return d }
            if let d = iso8601NoFractional.date(from: s) { return d }
            throw DecodingError.dataCorrupted(.init(codingPath: dec.codingPath,
                                                    debugDescription: "Invalid ISO8601 date: \(s)"))
        }

        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: LoginResponse.self, decoder: decoder) { response in
            #if DEBUG
            print("Status:", response.response?.statusCode ?? 0)
            if let data = response.data, let body = String(data: data, encoding: .utf8) {
                print("Body:", body)
            }
            #endif

            switch response.result {
            case .success(let payload):
                let tokenHeader =
                    (response.response?.allHeaderFields["Authorization"] as? String) ??
                    (response.response?.allHeaderFields["authorization"] as? String)
                completion(.success((payload, tokenHeader)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}



