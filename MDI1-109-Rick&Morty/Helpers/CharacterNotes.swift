//
//  CharacterNotes.swift
//  MDI1-109-Rick&Morty
//
//  Created by Christian Bonilla on 23/10/25.
//

import Foundation

enum CharacterNotes {
    static func key(_ id: Int) -> String { "rm_note_\(id)" }
    
    static func load(for id: Int) -> String {
        UserDefaults.standard.string(forKey: key(id)) ?? ""
    }
    
    static func save(_ text: String, for id: Int) {
        UserDefaults.standard.set(text, forKey: key(id))
    }
}
