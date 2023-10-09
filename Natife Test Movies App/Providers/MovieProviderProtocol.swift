//
//  MovieProviderProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MovieProviderProtocol {
    func getPopularMovies(page: Int, completion: @escaping (([Movie]) -> Void))
    func getMovieDetail(for movie: Movie, completion: @escaping ((MovieDetail) -> Void))
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

struct MovieDetail {
    let id: Int
    let genres: [GenreDTO]
}
