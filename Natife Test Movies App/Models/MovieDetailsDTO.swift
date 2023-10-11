//
//  MovieDetailsDTO.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

struct MovieDetailsDTO: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let productionCountries: [ProductionCountryDTO]
    let genres: [GenreDTO]
    let overview: String
    let rating: Double
    let video: Bool
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case productionCountries = "production_countries"
        case genres
        case overview
        case rating = "vote_average"
        case video
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

struct ProductionCountryDTO: Codable {
    let name: String
}
