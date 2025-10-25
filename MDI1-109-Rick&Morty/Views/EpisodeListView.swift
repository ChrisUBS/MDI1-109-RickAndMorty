//
//  EpisodeListView.swift
//  Rick&Morty
//
//  Created by Christian Bonilla on 25/10/25.
//

import SwiftUI

struct EpisodeListView: View {
    let episodes: [Episode]
    
    var body: some View {
        List(episodes) { episode in
            VStack(alignment: .leading) {
                Text(episode.episode)
                    .font(.headline)
                Text(episode.name)
                Text(episode.air_date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
