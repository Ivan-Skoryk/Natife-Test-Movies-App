//
//  MoviesListProviderProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MoviesListProviderProtocol {
    func getPopularMovies(page: Int, completion: @escaping ((Result<MoviesList, Error>) -> Void))
    func getMovieDetail(for movieID: Int, completion: @escaping ((Result<MovieDetails, Error>) -> Void))
    func searchMovie(by name: String, page: Int, completion: @escaping ((Result<MoviesList, Error>) -> Void))
}
