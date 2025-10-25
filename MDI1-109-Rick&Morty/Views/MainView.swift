//
//  CharactersView.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Picker("Resource", selection: $viewModel.selectedResource) {
                    ForEach(ResourceType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .onChange(of: viewModel.selectedResource) { _ in
                    viewModel.page = 1
                    Task { await viewModel.fetchData() }
                }

                TextField("Search by name...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("⚠️ \(error)")
                            .padding(.bottom, 5)
                        Button("Retry") { Task { await viewModel.fetchData() } }
                    }
                    .padding()
                } else {
                    Group {
                        switch viewModel.selectedResource {
                        case .characters:
                            if viewModel.characters.isEmpty {
                                Text("No characters found.")
                                    .foregroundColor(.gray)
                            } else {
                                CharacterListView(characters: viewModel.characters)
                            }
                        case .episodes:
                            if viewModel.episodes.isEmpty {
                                Text("No episodes found.")
                                    .foregroundColor(.gray)
                            } else {
                                EpisodeListView(episodes: viewModel.episodes)
                            }
                        case .locations:
                            if viewModel.locations.isEmpty {
                                Text("No locations found.")
                                    .foregroundColor(.gray)
                            } else {
                                LocationListView(locations: viewModel.locations)
                            }
                        }
                    }

                    // Pagination controls
                    HStack {
                        Button("◀ Prev") {
                            Task { await viewModel.prevPage() }
                        }
                        .disabled(viewModel.info?.prev == nil)

                        Text("Page \(viewModel.page)")
                            .padding(.horizontal)

                        Button("Next ▶") {
                            Task { await viewModel.nextPage() }
                        }
                        .disabled(viewModel.info?.next == nil)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Rick & Morty Browser")
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    MainView()
        .preferredColorScheme(ColorScheme.dark)
}
