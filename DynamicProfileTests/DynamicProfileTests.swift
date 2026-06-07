//
//  DynamicProfileTests.swift
//  DynamicProfileTests
//
//  Created by Anmol  Jandaur on 6/6/26.
//

import Testing
@testable import DynamicProfile
import Foundation

@MainActor
@Suite("ProfileViewModel Tests")
struct DynamicProfileTests {

    private func makeUser(id: Int = 1, name: String = "Test User", gender: String = "m", about: String? = "Looks at Camera", photo: URL? = URL(string: "https://example.com/image.png"), school: String? = nil, hobbies: [String]? = nil) -> User {
        return User(id: id, name: name, gender: gender, about: about, photo: photo, school: school, hobbies: hobbies)
    }
    
    private func makeConfig(fields: [String] = ["name", "photo", "gender", "about", "school"]) -> Config {
        Config(profile: fields)
    }
    
    private func loadedViewModel(users: [User], fields: [String] = ["name", "photo", "gender"]) async -> ProfileViewModel {
        let mock = MockNetworkService()
        mock.users = users
        mock.config = makeConfig(fields: fields)
        let viewModel = ProfileViewModel(networkService: mock)
        await viewModel.load()
        return viewModel
    }
    
    @Test("Produce loaded state with correct data")
    func loadProducesLoadedState() async {
        let viewModel = await loadedViewModel(users: [makeUser()])
        #expect(viewModel.state == .loaded)
    }
    
    @Test("Sets currentUser to first user after load")
    func loadSetsCurrentUserToFirst() async {
        let viewModel = await loadedViewModel(users: [makeUser()], fields: ["photo", "name","about"])
        #expect(viewModel.orderedFields == [.photo, .name, .about])
    }
    
    @Test("Maps config strings to correctly ordered fields")
       func loadMapsConfigToOrderedFields() async {
           let viewModel = await loadedViewModel(
               users: [makeUser()],
               fields: ["photo", "name", "about"]
           )
           #expect(viewModel.orderedFields == [.photo, .name, .about])
       }
    
       @Test("Drops unknown config strings silently")
       func loadDropsUnknownConfigStrings() async {
           let viewModel = await loadedViewModel(
               users: [makeUser()],
               fields: ["name", "unknownField", "photo"]
           )
           #expect(viewModel.orderedFields == [.name, .photo])
       }
    
       @Test("Produces empty state when users array is empty")
       func loadProducesEmptyState() async {
           let viewModel = await loadedViewModel(users: [])
           #expect(viewModel.state == .empty)
           #expect(viewModel.currentUser == nil)
       }
    
       @Test("Produces error state on network failure")
       func loadProducesErrorState() async {
           let mock = MockNetworkService()
           mock.fetchUsersError = NetworkError.invalidResponse
           let viewModel = ProfileViewModel(networkService: mock)
           await viewModel.load()
    
           guard case .error = viewModel.state else {
               Issue.record("Expected .error state, got \(viewModel.state)")
               return
           }
       }
    
       // MARK: - nextUser()
    
       @Test("Advances to next user")
       func nextUserAdvancesUser() async {
           let viewModel = await loadedViewModel(users: [
               makeUser(id: 1, name: "Jim"),
               makeUser(id: 2, name: "Pam")
           ])
           viewModel.nextUser()
           #expect(viewModel.currentUser?.id == 2)
           #expect(viewModel.currentUser?.name == "Pam")
       }
    
       @Test("Sets hasNextUser false after reaching last user")
       func hasNextUserIsFalseOnLastUser() async {
           let viewModel = await loadedViewModel(users: [
               makeUser(id: 1, name: "Jim"),
               makeUser(id: 2, name: "Pam")
           ])
           viewModel.nextUser()
           #expect(viewModel.hasNextUser == false)
       }
    
       @Test("hasNextUser is true when more users remain")
       func hasNextUserIsTrueWhenUsersRemain() async {
           let viewModel = await loadedViewModel(users: [
               makeUser(id: 1, name: "Jim"),
               makeUser(id: 2, name: "Pam"),
               makeUser(id: 3, name: "Michael")
           ])
           viewModel.nextUser()
           #expect(viewModel.hasNextUser == true)
       }


}
