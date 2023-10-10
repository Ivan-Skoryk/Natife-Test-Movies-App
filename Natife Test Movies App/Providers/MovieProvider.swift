//
//  MovieProvider.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MovieProvider {
    enum ImageSize: String {
        case w300 = "/w300/"
        case w500 = "/w500/"
        case w780 = "/w780/"
        case w1280 = "/w1280/"
        case original = "/original/"
    }
    
    private let networkManager: NetworkManagerProtocol!
    
    private var genres = [GenreDTO]()
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        getGenres()
    }
    
    private func getGenres() {
        let params = [
            "language": "en"
        ]
        
        networkManager.movieGenresRequest(params: params) { [weak self] result in
            self?.decodeData(of: GenresDTO.self, from: result) { [weak self] result in
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
            return "Release year: Unknown"
        }
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        return "\(year)"
    }
}

extension MovieProvider: MovieProviderProtocol {
    private func decodeData<T:Codable>(of type: T.Type, from result: Result<Data, Error>, completion: @escaping (((Result<T, Error>)) -> Void)) {
        switch result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
            break
        }
    }
    
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
            self?.decodeData(of: MoviesListDTO.self, from: result) { [weak self] result in
                self?.handleMoviesListDTOResult(result, completion: completion)
            }
        }
    }
    
    func getMovieDetail(for movieID: Int, completion: @escaping ((Result<MovieDetail, Error>) -> Void)) {
        if genres.count == 0 {
            getGenres()
        }
        
        networkManager.movieDetailRequest(movieID: movieID) { [weak self] result in
            self?.decodeData(of: MovieDetailDTO.self, from: result) { [weak self] result in
                switch result {
                case .success(let detailDTO):
                    let countries = detailDTO.productionCountries.map { $0.name }
                    let year = self?.extractYear(from: detailDTO.releaseDate) ?? "Unknown"
                    let posterURL = self?.getImageURL(for: detailDTO.posterPath, imageSize: .original) ?? ""
                    let backdropURL = self?.getImageURL(for: detailDTO.backdropPath, imageSize: .original) ?? ""
                    
                    let detail = MovieDetail(
                        id: detailDTO.id,
                        genres: detailDTO.genres,
                        title: detailDTO.title,
                        countries: countries,
                        year: year,
                        rating: detailDTO.rating,
                        overview: detailDTO.overview,
                        video: detailDTO.video,
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
            self?.decodeData(of: MoviesListDTO.self, from: result) { [weak self] result in
                self?.handleMoviesListDTOResult(result, completion: completion)
            }
        }
    }
}
