//
//  MoviesListViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MoviesListViewModelProtocol {
    var movies: [Movie] { get }
    var selectedSorting: SortingOption { get }
    
    func selectSorting(option: SortingOption)
    func setSearchString(string: String)
    func cancelSearch()
    func getMovies(reloadAll: Bool, completion: @escaping (() -> Void))
    func navigateToMovieDetail(index: Int)
}

enum SortingOption: Int, CaseIterable {
    case popular = 0
    case nameAsc
    case nameDesc
    case yearAsc
    case yearDesc
    case ratingAsc
    case ratingDesc
    
    var title: String {
        switch self {
        case .popular: "Popularity"
        case .nameAsc: "Name (A-Z)"
        case .nameDesc: "Name (Z-A)"
        case .yearAsc: "Year (Asc)"
        case .yearDesc: "Year (Desc)"
        case .ratingAsc: "Rating (Asc)"
        case .ratingDesc: "Rating (Desc)"
        }
    }
}

final class MoviesListViewModel {
    var moviesProvider: MoviesListProviderProtocol
    var router: MoviesListRouterProtocol!
    
    private var popularMovies = [Movie]()
    private var sortedMovies = [Movie]()
    private var searchedMovies = [Movie]()
    private var searchedSorted = [Movie]()
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
    
    var selectedSorting = SortingOption.popular
    
    init(moviesProvider: MoviesListProviderProtocol) {
        self.moviesProvider = moviesProvider
    }
    
    private func sortMovies(_ movies: [Movie]) -> [Movie] {
        switch selectedSorting {
        case .popular: return movies
        case .nameAsc: return movies.sorted(by: { $0.title < $1.title })
        case .nameDesc: return movies.sorted(by: { $0.title > $1.title })
        case .yearAsc: return movies.sorted(by: { $0.year < $1.year })
        case .yearDesc: return movies.sorted(by: { $0.year > $1.year })
        case .ratingAsc: return movies.sorted(by: { $0.rating < $1.rating })
        case .ratingDesc: return movies.sorted(by: { $0.rating > $1.rating })
        }
    }
    
    private func getMovieDetail(for index: Int, completion: @escaping ((Result<MovieDetails, Error>) -> Void)) {
        let movie = isSearching ? searchedMovies[index].id : sortedMovies[index].id
        moviesProvider.getMovieDetail(for: movie, completion: completion)
    }
    
    private func getPopularMovies(reloadAll: Bool = false, completion: @escaping (() -> Void)) {
        let page = reloadAll ? 1 : (popularMovies.count / 20) + 1
        
        guard page <= maxPages else {
            completion()
            return
        }
        
        moviesProvider.getPopularMovies(page: page) { [weak self] result in
            switch result {
            case .success(let list):
                if reloadAll {
                    self?.popularMovies.removeAll()
                }
                self?.popularMovies.append(contentsOf: list.movies)
                self?.sortedMovies += self?.sortMovies(list.movies) ?? []
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
                self?.searchedSorted += self?.sortMovies(list.movies) ?? []
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
        isSearching 
        ? selectedSorting == .popular ? searchedMovies : searchedSorted
        : selectedSorting == .popular ? popularMovies : sortedMovies
    }
    
    func selectSorting(option: SortingOption) {
        selectedSorting = option
        searchedSorted = sortMovies(searchedMovies)
        sortedMovies = sortMovies(popularMovies)
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
