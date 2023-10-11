//
//  MovieVideoDTO.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

struct MovieVideosDTO: Codable {
    let id: Int
    let results: [MovieVideoDTO]
}

struct MovieVideoDTO: Codable {
    let id: String
    let publishedAt: String
    let name: String
    let site: String
    let type: String
    let official: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case publishedAt = "published_at"
        case name
        case site
        case type
        case official
        case key
    }
}
