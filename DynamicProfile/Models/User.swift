//
//  User.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/6/26.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: Int
    let name: String
    let gender: String
    let about: String?
    let photo: URL?
    let school: String?
    let hobbies: [String]?
}
