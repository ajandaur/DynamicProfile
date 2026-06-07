//
//  MockNetworkService.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/6/26.
//
import Foundation
 
final class MockNetworkService: NetworkServiceProtocol {
 
    var users: [User] = []
    var config: Config = Config(profile: [])
    var fetchUsersError: Error?
    var fetchConfigError: Error?
 
    func fetchUsers() async throws -> [User] {
        if let error = fetchUsersError { throw error }
        return users
    }
 
    func fetchConfig() async throws -> Config {
        if let error = fetchConfigError { throw error }
        return config
    }
}
 
