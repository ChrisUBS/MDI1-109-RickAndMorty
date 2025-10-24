//
//  CharactersVM.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import Foundation
import SwiftUI
import Combine

enum LoadState: Equatable {
    case idle, loading, loaded, failed(String)
}

@MainActor
final class CharactersVM: ObservableObject {
    @Published var characters: [RMCharacter] = []
    @Published var info: Info? = nil
    @Published var state: LoadState = .idle
    @Published var searchText: String = ""
    
    private let api = APIClient()
    private var currentPage: Int = 1
    
    func firstLoad() async {
        await load(page: 1, name: nil)
    }
    
    func applySearch() async {
        currentPage = 1
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }
    
    func nextPage() async {
        guard let i = info, i.next != nil else { return }
        currentPage += 1
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }
    
    func prevPage() async {
        guard let i = info, i.prev != nil else { return }
        currentPage = max(1, currentPage - 1)
        await load(page: currentPage, name: searchText.isEmpty ? nil : searchText)
    }
    
    func load(page: Int?, name: String?) async {
        state = .loading
        do {
            let resp = try await api.fetchCharacters(page: page, name: name)
            characters = resp.results
            info = resp.info
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
