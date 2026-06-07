//
//  ProfileFieldType.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/6/26.
//

import Foundation

enum ProfileFieldType: String {
    case name
    case photo
    case gender
    case about
    case school
    case hobbies
}
 
extension ProfileFieldType {
    static func ordered(from config: Config) -> [ProfileFieldType] {
        config.profile.compactMap { ProfileFieldType(rawValue: $0) }
    }
}
 
