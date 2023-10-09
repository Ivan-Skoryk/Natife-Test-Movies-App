//
//  Movie.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

struct MovieDTO: Codable {
    let id: Int
    let rating: Double
    let releaseDate: String
    let title: String
    let posterPath: String
    let backdropPath: String
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
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie {
    let id: Int
    let rating: Double
    let year: String
    let title: String
    let posterImageURLString: String
    let backdropwImageURLString: String
    let genres: [GenreDTO]
    let video: Bool
}

struct MovieDetailDTO: Codable {
    let id: Int
    let title: String
    let releaseDate: String
    let productionCountries: [ProductionCountry]
    let genres: [GenreDTO]
    let overview: String
    let rating: Double
    let video: Bool
    let posterPath: String
    let backdropPath: String
    
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

struct ProductionCountry: Codable {
    let name: String
}

struct MovieDetail {
    let id: Int
    let genres: [GenreDTO]
    let title: String
    let countries: [String]
    let year: String
    let rating: Double
    let overview: String
    let video: Bool
    let posterImageURLString: String
    let backdropImageURLString: String
}
