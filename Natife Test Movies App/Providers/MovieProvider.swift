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
    
    let networkManager = NetworkManager.shared
    
    private var genres = [GenreDTO]()
    
    init() {
        getGenres()
    }
    
    func getGenres() {
        let params = [
            "language": "en"
        ]
        
        networkManager.movieGenresRequest(params: params) { result in
            switch result {
            case .success(let data):
                do {
                    let genres = try JSONDecoder().decode(GenresDTO.self, from: data)
                    self.genres = genres.genres
                } catch {
                    // TODO: handle error
                }
            case .failure(_):
                // TODO: handle error
                break
            }
        }
    }
    
    private func convertMoviesDTO(movies: [MovieDTO], completion: @escaping (([Movie]) -> Void)) {
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
        
        completion(result)
    }
    
    private func getImageURL(for path: String, imageSize: ImageSize) -> String {
        return NetworkManager.Constants.baseImageStorageURL + imageSize.rawValue + path
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
    func getPopularMovies(page: Int, completion: @escaping (([Movie]) -> Void)) {
        let params: [String: Any] = [
            "language": "en",
            "page": page
        ]
        
        networkManager.popularMoviesRequest(params: params) { result in
            switch result {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode(MoviesListDTO.self, from: data)
                    self.convertMoviesDTO(movies: list.movies, completion: completion)
                } catch {
                    // TODO: handle error
                }
            case .failure(_):
                // TODO: handle error
                break
            }
        }
    }
    
    func getMovieDetail(for movie: Movie, completion: @escaping ((MovieDetail) -> Void)) {
        
    }
}
