//
//  MainViewModel.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//

import Foundation
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var selectedResource: ResourceType = .characters
    @Published var searchQuery = ""
    @Published var page = 1
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var info: Info?
    
    @Published var characters: [RMCharacter] = []
    @Published var episodes: [Episode] = []
    @Published var locations: [Location] = []

    private var currentTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Debounced search (≈300 ms)
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                Task { await self?.fetchData() }
            }
            .store(in: &cancellables)
    }
    
    func fetchData() async {
        currentTask?.cancel()
        currentTask = Task {
            await loadData()
        }
    }
    
    private func loadData() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            switch selectedResource {
            case .characters:
                let response: APIResponse<RMCharacter> =
                    try await APIClient.shared.fetch(resource: .characters, page: page, query: searchQuery)
                characters = response.results
                info = response.info
                
            case .episodes:
                let response: APIResponse<Episode> =
                    try await APIClient.shared.fetch(resource: .episodes, page: page, query: searchQuery)
                episodes = response.results
                info = response.info
                
            case .locations:
                let response: APIResponse<Location> =
                    try await APIClient.shared.fetch(resource: .locations, page: page, query: searchQuery)
                locations = response.results
                info = response.info
            }
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func nextPage() async {
        guard info?.next != nil else { return }
        page += 1
        await fetchData()
    }
    
    func prevPage() async {
        guard info?.prev != nil else { return }
        page = max(1, page - 1)
        await fetchData()
    }
}
