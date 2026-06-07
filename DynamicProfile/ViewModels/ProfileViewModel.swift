//
//  ProfileViewModel.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/6/26.
//

import Foundation
import Observation

@Observable
final class ProfileViewModel {

    // MARK: - State

    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    private var state: ViewState = .idle
    private var currentUser: User?
    private var orderedFields: [ProfileFieldType] = []
    private var hasNextUser: Bool = false

    // MARK: - Private

    private var users: [User] = []
    private var currentIndex: Int = 0
    private let networkService: NetworkServiceProtocol

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Public

    func load() async {
        state = .loading

        do {
            async let fetchedUsers = networkService.fetchUsers()
            async let fetchedConfig = networkService.fetchConfig()

            // suspend until both finish, error out if either throws
            let (users, config) = try await (fetchedUsers, fetchedConfig)

            self.users = users
            self.orderedFields = ProfileFieldType.ordered(from: config)
            self.currentIndex = 0

            if users.isEmpty {
                self.state = .empty
            } else {
                self.currentUser = users[0]
                self.hasNextUser = users.count > 1
                self.state = .loaded
            }
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }

    func nextUser() {
        guard currentIndex < users.count - 1 else { return }
        currentIndex += 1
        currentUser = users[currentIndex]
        hasNextUser = currentIndex < users.count - 1
    }
}
