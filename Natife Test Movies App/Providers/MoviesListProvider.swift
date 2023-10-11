//
//  MoviesListProvider.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MoviesListProvider {
    enum ImageSize: String {
        case w300 = "/w300/"
        case w500 = "/w500/"
        case w780 = "/w780/"
        case w1280 = "/w1280/"
        case original = "/original/"
    }
    
    private let networkManager: MovieListNetworkManagerProtocol!
    
    private var genres = [GenreDTO]()
    
    init(networkManager: MovieListNetworkManagerProtocol) {
        self.networkManager = networkManager
        getGenres()
    }
    
    private func getGenres() {
        networkManager.movieGenresRequest() { [weak self] result in
            decodeData(of: GenresDTO.self, from: result) { [weak self] result in
                switch result {
                case .success(let genres):
                    self?.genres = genres.genres
                case .failure(let error):
                    print("genres load failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func convertMoviesDTO(movies: [MovieDTO]) -> [Movie] {
        var result = [Movie]()
        for movie in movies {
            let year = extractYear(from: movie.releaseDate)
            let genres = genres.filter { movie.genres.contains($0.id) }
            let mov = Movie(
                id: movie.id,
                rating: movie.rating,
                year: year,
                title: movie.title,
                posterImageURLString: getImageURL(for: movie.posterPath, imageSize: .w780),
                backdropwImageURLString: getImageURL(for: movie.backdropPath, imageSize: .w1280),
                genres: genres,
                video: movie.video
            )
            result.append(mov)
        }
        
        return result
    }
    
    private func getImageURL(for path: String?, imageSize: ImageSize) -> String? {
        path != nil
        ? NetworkManager.Constants.baseImageStorageURL + imageSize.rawValue + path!
        : nil
    }
    
    private func extractYear(from date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        guard let date = formatter.date(from: date) else {
            return "Release year: Unknown".localized
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
}

extension MoviesListProvider: MoviesListProviderProtocol {
    private func handleMoviesListDTOResult(
        _ result: Result<MoviesListDTO, Error>,
        completion: @escaping ((Result<MoviesList, Error>) -> Void)
    ) {
        switch result {
        case .success(let list):
            let movies = self.convertMoviesDTO(movies: list.movies)
            let list = MoviesList(movies: movies, totalPages: list.totalPages)
            completion(.success(list))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func getPopularMovies(page: Int, completion: @escaping ((Result<MoviesList, Error>) -> Void)) {
        if genres.count == 0 {
            getGenres()
        }
        
        networkManager.popularMoviesRequest(page: page) { [weak self] result in
            decodeData(of: MoviesListDTO.self, from: result) { [weak self] result in
                self?.handleMoviesListDTOResult(result, completion: completion)
            }
        }
    }
    
    func getMovieDetail(for movieID: Int, completion: @escaping ((Result<MovieDetails, Error>) -> Void)) {
        if genres.count == 0 {
            getGenres()
        }
        
        networkManager.movieDetailRequest(movieID: movieID) { [weak self] result in
            decodeData(of: MovieDetailsDTO.self, from: result) { [weak self] result in
                switch result {
                case .success(let detailsDTO):
                    let countries = detailsDTO.productionCountries.map { $0.name }
                    let year = self?.extractYear(from: detailsDTO.releaseDate) ?? "Unknown".localized
                    let posterURL = self?.getImageURL(for: detailsDTO.posterPath, imageSize: .original) ?? ""
                    let backdropURL = self?.getImageURL(for: detailsDTO.backdropPath, imageSize: .original) ?? ""
                    
                    let detail = MovieDetails(
                        id: detailsDTO.id,
                        genres: detailsDTO.genres,
                        title: detailsDTO.title,
                        countries: countries,
                        year: year,
                        rating: detailsDTO.rating,
                        overview: detailsDTO.overview,
                        video: detailsDTO.video,
                        posterImageURLString: posterURL,
                        backdropImageURLString: backdropURL
                    )
                    completion(.success(detail))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func searchMovie(by name: String, page: Int, completion: @escaping ((Result<MoviesList, Error>) -> Void)) {
        if genres.count == 0 {
            getGenres()
        }
        
        networkManager.searchMovieRequest(name: name, page: page) { [weak self] result in
            decodeData(of: MoviesListDTO.self, from: result) { [weak self] result in
                self?.handleMoviesListDTOResult(result, completion: completion)
            }
        }
    }
}
