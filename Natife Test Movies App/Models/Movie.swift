//
//  Movie.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

struct Movie {
    let id: Int
    let rating: Double
    let year: String
    let title: String
    let posterImageURLString: String?
    let backdropImageURLString: String?
    let genres: [GenreDTO]
    let video: Bool
}

struct MoviesList {
    let movies: [Movie]
    let totalPages: Int
}
