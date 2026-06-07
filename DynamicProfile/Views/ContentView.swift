//
//  ContentView.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/7/26.
//

import SwiftUI

struct ContentView: View {

    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .navigationTitle("Red Teapot Dating")
                    .navigationBarTitleDisplayMode(.large)

            case .loaded:
                if let user = viewModel.currentUser {
                    ProfileView(
                        user: user,
                        orderedFields: viewModel.orderedFields,
                        hasNextUser: viewModel.hasNextUser,
                        onNext: viewModel.nextUser
                    )
                    .navigationTitle("Red Teapot Dating")
                    .navigationBarTitleDisplayMode(.inline)
                }

            case .empty:
                ContentUnavailableView(
                    "No Profiles",
                    systemImage: "person.slash",
                    description: Text("Check back later.")
                )
                .navigationTitle("Red Teapot Dating")
                .navigationBarTitleDisplayMode(.large)

            case .error(let message):
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Button("Try Again") {
                        Task { await viewModel.load() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Red Teapot Dating")
                .navigationBarTitleDisplayMode(.large)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
#Preview {
    ContentView()
}
