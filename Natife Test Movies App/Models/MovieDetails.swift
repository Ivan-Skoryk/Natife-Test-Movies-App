//
//  MovieDetails.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

struct MovieDetails {
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
