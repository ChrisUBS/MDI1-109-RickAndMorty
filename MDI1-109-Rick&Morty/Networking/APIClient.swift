//
//  APIClient.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import Foundation

enum APIResource: String {
    case characters = "character"
    case episodes = "episode"
    case locations = "location"
}

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let baseURL = "https://rickandmortyapi.com/api"
    
    func fetch<T: Codable>(
        resource: APIResource,
        page: Int,
        query: String = ""
    ) async throws -> APIResponse<T> {
        var components = URLComponents(string: "\(baseURL)/\(resource.rawValue)")
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        if !query.isEmpty {
            queryItems.append(URLQueryItem(name: "name", value: query))
        }
        
        components?.queryItems = queryItems
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(APIResponse<T>.self, from: data)
    }
}
