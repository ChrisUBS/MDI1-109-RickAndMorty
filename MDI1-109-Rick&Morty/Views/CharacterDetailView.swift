//
//  CharacterDetailView.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: RMCharacter
    @State private var note: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // MARK: - Character image
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)

                // MARK: - Basic info
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.primary)
                    Text("\(character.species) • \(character.status)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Divider()

                // MARK: - Notes section
                Text("My Notes")
                    .font(.headline)
                    .foregroundColor(.primary)

                TextEditor(text: $note)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .foregroundColor(.primary)

                Button("Save Note") {
                    CharacterNotes.save(note, for: character.id)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            note = CharacterNotes.load(for: character.id)
        }
    }
}

#Preview {
    CharacterDetailView(
        character: RMCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: []
        )
    )
}
