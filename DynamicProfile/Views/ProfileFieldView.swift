//
//  ProfileFieldView.swift
//  DynamicProfile
//
//  Created by Anmol  Jandaur on 6/7/26.
//

import SwiftUI

struct ProfileFieldView: View {
    
    let field: ProfileFieldType
    let user: User
    
    var body: some View {
        switch field {
        case .name:
            Text(user.name)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            
        case .photo:
            if let url = user.photo {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .clipped()
                        
                    case .failure:
                        Rectangle()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .overlay {
                                Image(systemName: "person.crop.rectangle")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                        
                    case .empty:
                        Rectangle()
                            .fill(Color.secondary.opacity(0.1))
                            .frame(maxWidth: .infinity)
                            .frame(height: 400)
                            .overlay {
                                ProgressView()
                            }
                    
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        case .gender:
            LabeledFieldView(label: "Gender", value: user.gender.genderDisplay)
            
        case .about:
            if let about = user.about {
                LabeledFieldView(label: "About", value: about)
            }
            
        case .school:
            if let school = user.school {
                LabeledFieldView(label: "School", value: school)
            }
            
        case .hobbies:
            if let hobbies = user.hobbies, !hobbies.isEmpty {
                LabeledFieldView(label: "Hobbies", value: hobbies.joined(separator: ", "))
            }
        }
        
    }
    private struct LabeledFieldView: View {
        let label: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.headline)
                Text(value)
                    .font(.body)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}



private extension String {
    var genderDisplay: String {
        switch self.lowercased() {
        case "m": return "Male"
        case "f": return "Female"
        default: return self
        }
    }
}
