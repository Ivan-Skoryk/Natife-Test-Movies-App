//
//  MovieDTO.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

struct MovieDTO: Codable {
    let id: Int
    let rating: Double
    let releaseDate: String
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let genres: [Int]
    let video: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case rating = "vote_average"
        case releaseDate = "release_date"
        case title
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genres = "genre_ids"
        case video
    }
}

struct MoviesListDTO: Codable {
    let movies: [MovieDTO]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
        case totalPages = "total_pages"
    }
}
