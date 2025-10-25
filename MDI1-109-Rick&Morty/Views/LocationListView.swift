//
//  LocationListView.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//
import SwiftUI

struct LocationListView: View {
    let locations: [Location]
    
    var body: some View {
        List(locations) { loc in
            VStack(alignment: .leading) {
                Text(loc.name)
                    .font(.headline)
                Text("\(loc.type) · \(loc.dimension)")
                    .foregroundColor(.gray)
                Text("Residents: \(loc.residents.count)")
                    .font(.caption)
            }
        }
    }
}
