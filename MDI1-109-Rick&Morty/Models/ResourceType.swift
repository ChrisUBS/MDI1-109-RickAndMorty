//
//  ResourceType.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//

enum ResourceType: String, CaseIterable, Identifiable {
    case characters = "Characters"
    case episodes = "Episodes"
    case locations = "Locations"

    var id: String { rawValue }
}
