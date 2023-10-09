//
//  Genre.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

struct GenreDTO: Codable {
    let id: Int
    let name: String
}

struct GenresDTO: Codable {
    let genres: [GenreDTO]
}
