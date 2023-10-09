//
//  MovieProviderProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MovieProviderProtocol {
    func getPopularMovies(page: Int, completion: @escaping (([Movie]) -> Void))
    func getMovieDetail(for movieID: Int, completion: @escaping ((MovieDetail) -> Void))
}
