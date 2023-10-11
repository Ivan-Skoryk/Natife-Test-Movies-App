//
//  MovieListNetworkManagerProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

protocol MovieListNetworkManagerProtocol {
    func searchMovieRequest(name: String, page: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func popularMoviesRequest(page: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func movieDetailRequest(movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func movieGenresRequest(completion: @escaping ((Result<Data, Error>) -> Void))
}
