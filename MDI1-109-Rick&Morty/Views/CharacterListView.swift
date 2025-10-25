//
//  CharacterListView.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//

import SwiftUI

struct CharacterListView: View {
    let characters: [RMCharacter]

    var body: some View {
        List(characters) { character in
            NavigationLink(destination: CharacterDetailView(character: character)) {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: character.image)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 60, height: 60)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(character.name)
                            .font(.headline)
                        Text("\(character.species) • \(character.status)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    let sampleCharacter = RMCharacter(
        id: 1,
        name: "Rick Sanchez",
        status: "alive",
        species: "human",
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: []
    )
    let characters: [RMCharacter] = [sampleCharacter]
    CharacterListView(characters: characters)
        .preferredColorScheme(.dark)
}
