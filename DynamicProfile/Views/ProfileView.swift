//
//  ProfileView.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/7/26.
//

import SwiftUI

struct ProfileView: View {

    let user: User
    let orderedFields: [ProfileFieldType]
    let hasNextUser: Bool
    let onNext: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(orderedFields, id: \.self) { field in
                        ProfileFieldView(field: field, user: user)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 80)
            }

            if hasNextUser {
                Button(action: onNext) {
                    Image(systemName: "arrow.right")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(20)
                        .background(Color.teal)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    ProfileView(
        user: User(
            id: 1,
            name: "Alex Johnson",
            gender: "F",
            about: "Coffee enthusiast and bookworm. Always looking for the next adventure!",
            photo: URL(string: "https://picsum.photos/400/400"),
            school: "Stanford University",
            hobbies: ["Reading", "Hiking", "Photography"]
        ),
        orderedFields: [.photo, .name, .about, .school, .hobbies],
        hasNextUser: true,
        onNext: {}
    )
}

