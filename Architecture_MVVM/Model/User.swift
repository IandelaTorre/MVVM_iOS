//
//  User.swift
//  Architecture_MVVM
//
//  Created by Ian Axel Perez de la Torre on 27/07/25.
//

import Foundation

struct User {
    let name: String
    let token: String
    let sessionStart: Date
}

struct Post: Decodable {
    let user: String
    let password: String
    let time: Int
}

struct LoginResponse: Decodable {
    let id: Int
    let uuid: String
    let email: String
    let name: String
    let lastName: String
    let secondLastName: String
    let createdAt: Date
    let updatedAt: Date
    let enabled: Bool
    let rolId: Int
    let rol: RoleResponse
}

struct RoleResponse: Decodable {
    let id: Int
    let uuid: String
    let name: String
    let visualName: String
    let createdAt: Date
    let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case id, uuid, name, createdAt, enabled
        case visualName = "visual_name"
    }
}

