//
//  NetworkManager+MovieList.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

extension NetworkManager: MovieListNetworkManagerProtocol {
    func searchMovieRequest(name: String, page: Int,  completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params: [String: Any] = [
            "query": name,
            "include_adult": false,
            "language": Locale.current.languageCode ?? "en",
            "page": page
        ]
        
        let url = Constants.baseURLString + Endpoints.search.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func popularMoviesRequest(page: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params: [String: Any] = [
            "page": page,
            "language": Locale.current.languageCode ?? "en",
        ]
        
        let url = Constants.baseURLString + Endpoints.popular.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func movieDetailRequest(movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params = [
            "language": Locale.current.languageCode ?? "en"
        ]
        let url = Constants.baseURLString + Endpoints.details.rawValue + "\(movieID)"
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func movieGenresRequest(completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params = [
            "language": Locale.current.languageCode ?? "en"
        ]
        
        let url = Constants.baseURLString + Endpoints.genres.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
}
