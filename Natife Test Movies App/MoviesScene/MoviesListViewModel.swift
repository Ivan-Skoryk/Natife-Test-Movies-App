//
//  MoviesListViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

class MoviesListViewModel {
    var movies = [Movie]()
    
    var moviesProvider: MovieProviderProtocol
    var router: MoviesListRouterProtocol!
    
    init(moviesProvider: MovieProviderProtocol) {
        self.moviesProvider = moviesProvider
    }
    
    func getMovies(completion: @escaping (() -> Void)) {
        let page = (movies.count / 20) + 1
        moviesProvider.getPopularMovies(page: page) { [weak self] movies in
            self?.movies.append(contentsOf: movies)
            completion()
        }
    }
    
    private func getMovieDetail(for index: Int, completion: @escaping ((MovieDetail) -> Void)) {
        moviesProvider.getMovieDetail(for: movies[index].id, completion: completion)
    }
    
    func navigateToMovieDetail(index: Int) {
        getMovieDetail(for: index) { [weak self] detail in
            self?.router.navigateToMovieDetails(movieDetail: detail)
        }
    }
}
