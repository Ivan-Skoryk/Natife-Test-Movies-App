//
//  MoviesListViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MoviesListViewModelProtocol {
    var movies: [Movie] { get }
    
    func setSearchString(string: String)
    func cancelSearch()
    func getMovies(reloadAll: Bool, completion: @escaping (() -> Void))
    func navigateToMovieDetail(index: Int)
}

final class MoviesListViewModel {
    var moviesProvider: MoviesListProviderProtocol
    var router: MoviesListRouterProtocol!
    
    private var sortedMovies = [Movie]()
    private var searchedMovies = [Movie]()
    private let maxPages = 500
    private var searchMaxPages = 500
    
    private var isSearching = false {
        didSet {
            if !isSearching {
                searchMaxPages = 500
            }
        }
    }
    private var searchString = ""
    
    init(moviesProvider: MoviesListProviderProtocol) {
        self.moviesProvider = moviesProvider
    }
    
    private func getMovieDetail(for index: Int, completion: @escaping ((Result<MovieDetails, Error>) -> Void)) {
        let movie = isSearching ? searchedMovies[index].id : sortedMovies[index].id
        moviesProvider.getMovieDetail(for: movie, completion: completion)
    }
    
    private func getPopularMovies(reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        let page = reloadAll ? 1 : (sortedMovies.count / 20) + 1
        
        guard page <= maxPages else {
            completion()
            return
        }
        
        moviesProvider.getPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let list):
                if reloadAll {
                    self?.sortedMovies.removeAll()
                }
                self?.sortedMovies.append(contentsOf: list.movies)
                completion()
            case .failure(let error):
                self?.router.presentError(error) {
                    completion()
                }
            }
        }
    }
    
    private func searchMovies(by name: String, reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        let page = reloadAll ? 1 : Int(ceil(Float(searchedMovies.count) / 20) + 1)
        
        guard page <= searchMaxPages else {
            completion()
            return
        }
        
        moviesProvider.searchMovie(by: name, page: page) { [weak self] result in
            switch result {
            case .success(let list):
                if reloadAll {
                    self?.searchedMovies.removeAll()
                }
                self?.searchedMovies.append(contentsOf: list.movies)
                self?.searchMaxPages = list.totalPages
                completion()
            case .failure(let error):
                if NetworkError.noConnection == error as? NetworkError {
                    self?.searchedMovies = self?.sortedMovies.filter { $0.title.contains(name) } ?? []
                    completion()
                } else {
                    self?.router.presentError(error) {
                        completion()
                    }
                }
            }
        }
    }
}

extension MoviesListViewModel: MoviesListViewModelProtocol {
    var movies: [Movie] {
        isSearching ? searchedMovies : sortedMovies
    }
    
    func getMovies(reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        if isSearching {
            searchMovies(by: searchString, reloadAll: reloadAll, completion: completion)
        } else {
            getPopularMovies(reloadAll: reloadAll, completion: completion)
        }
    }
    
    func navigateToMovieDetail(index: Int) {
        getMovieDetail(for: index) { [weak self] result in
            switch result {
            case .success(let details):
                self?.router.navigateToMovieDetails(movieDetails: details)
            case .failure(let error):
                self?.router.presentError(error) {}
            }
        }
    }
    
    func setSearchString(string: String) {
        guard !string.isEmpty else { return }
        searchString = string
        searchedMovies.removeAll()
        isSearching = true
    }
    
    func cancelSearch() {
        searchString = ""
        isSearching = false
        searchedMovies.removeAll()
    }
}
