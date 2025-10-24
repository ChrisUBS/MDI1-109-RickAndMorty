//
//  CharactersView.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import SwiftUI

struct CharactersView: View {
    @StateObject private var vm = CharactersVM()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Header
                    Text("Rick & Morty")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 10)

                    // MARK: - Search bar
                    HStack {
                        TextField("Search name (e.g. Rick)", text: $vm.searchText)
                            .padding(10)
                            .background(Color(.darkGray).opacity(0.3))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .submitLabel(.search)
                            .onSubmit {
                                Task { await vm.applySearch() }
                            }

                        if vm.state == .loading {
                            ProgressView()
                                .tint(.white)
                                .padding(.leading, 5)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 5)

                    // MARK: - Characters list
                    Group {
                        switch vm.state {
                        case .idle, .loading:
                            Spacer()
                            ProgressView("Loading...")
                                .tint(.white)
                            Spacer()

                        case .failed(let error):
                            Spacer()
                            VStack(spacing: 8) {
                                Text("Error: \(error)")
                                    .foregroundColor(.red)
                                Button("Retry") {
                                    Task { await vm.firstLoad() }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            Spacer()

                        case .loaded:
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(vm.characters) { character in
                                        NavigationLink {
                                            CharacterDetailView(character: character)
                                        } label: {
                                            HStack(spacing: 12) {
                                                AsyncImage(url: URL(string: character.image)) { image in
                                                    image.resizable().scaledToFill()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 60, height: 60)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(character.name)
                                                        .font(.headline)
                                                        .foregroundColor(.white)
                                                    Text("\(character.species) • \(character.status)")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                }

                                                Spacer()
                                            }
                                            .padding(10)
                                            .background(Color(.systemGray6).opacity(0.1))
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, 4)
                            }
                        }
                    }

                    // MARK: - Pagination
                    HStack {
                        Button("Prev") {
                            Task { await vm.prevPage() }
                        }
                        .disabled(vm.info?.prev == nil)
                        .foregroundColor(vm.info?.prev == nil ? .gray : .blue)

                        Spacer()

                        Button("Next") {
                            Task { await vm.nextPage() }
                        }
                        .disabled(vm.info?.next == nil)
                        .foregroundColor(vm.info?.next == nil ? .gray : .blue)
                    }
                    .padding()
                }
            }
            .task { await vm.firstLoad() }
        }
    }
}

#Preview {
    CharactersView()
}
