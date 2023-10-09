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
        
        networkManager.movieGenresRequest(params: params) { [weak self] result in
            self?.decodeData(of: GenresDTO.self, from: result) { [weak self] genres in
                self?.genres = genres.genres
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
    func decodeData<T:Codable>(of type: T.Type, from result: Result<Data, Error>, completion: @escaping ((T) -> Void)) {
        switch result {
        case .success(let data):
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(decoded)
            } catch {
                // TODO: handle error
            }
        case .failure(_):
            // TODO: handle error
            break
        }
    }
    
    func getPopularMovies(page: Int, completion: @escaping (([Movie]) -> Void)) {
        let params: [String: Any] = [
            "language": "en",
            "page": page
        ]
        
        networkManager.popularMoviesRequest(params: params) { [weak self] result in
            self?.decodeData(of: MoviesListDTO.self, from: result) { [weak self] list in
                self?.convertMoviesDTO(movies: list.movies, completion: completion)
            }
        }
    }
    
    func getMovieDetail(for movieID: Int, completion: @escaping ((MovieDetail) -> Void)) {
        networkManager.movieDetailRequest(movieID: movieID) { [weak self] result in
            self?.decodeData(of: MovieDetailDTO.self, from: result) { [weak self] detailDTO in
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
                completion(detail)
            }
        }
    }
}
