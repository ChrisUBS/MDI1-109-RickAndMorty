//
//  APIResponse.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//

import Foundation
import Combine

struct APIResponse<T: Codable>: Codable {
    let info: Info
    let results: [T]
}
