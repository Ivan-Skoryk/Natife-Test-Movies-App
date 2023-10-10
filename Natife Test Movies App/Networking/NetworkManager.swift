//
//  NetworkManager.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case noData
    case noConnection
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            NSLocalizedString("No Data Available", comment: "")
        case .noConnection:
            NSLocalizedString("You are offline. Please, enable your Wi-Fi or connect using cellular data.", comment: "")
        }
    }
}

protocol NetworkManagerProtocol {
    func searchMovieRequest(name: String, page: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func popularMoviesRequest(page: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func movieDetailRequest(movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void))
    func movieGenresRequest(params: Parameters, completion: @escaping ((Result<Data, Error>) -> Void))
}

final class NetworkManager {
    static var shared = NetworkManager()
    
    enum Constants {
        static let baseURLString = "https://api.themoviedb.org/3/"
        static let baseImageStorageURL = "https://image.tmdb.org/t/p"
    }
    
    enum Endpoints: String {
        case search = "search/movie"
        case popular = "movie/popular"
        case detail = "movie/"
        case genres = "genre/movie/list"
    }
    
    private let baseHeaders: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDc0NTNiNmM4MzA3MWY1ODc1MWY0NTE3OTJlYzMxMSIsInN1YiI6IjY1MjJhOWZjMDcyMTY2MDBhY2I4ZjkyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9Q0Hs_dyRT-Xh6wMBjXLBbp6O9BUm9NkiuuFVooOq2k"
    ]
    
    let reachability = NetworkReachabilityManager.default
    
    private func baseRequest(
        url: String,
        params: Parameters? = nil,
        completion: @escaping ((Result<Data, Error>) -> Void)
    ) {
        guard reachability?.isReachable == true else {
            completion(.failure(NetworkError.noConnection))
            return
        }
        
        AF.request(url, method: .get, parameters: params, headers: baseHeaders)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    completion(.success(data))
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
    }
}

extension NetworkManager: NetworkManagerProtocol {
    func searchMovieRequest(name: String, page: Int,  completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params: [String: Any] = [
            "query": name,
            "include_adult": false,
            "language": "en-US",
            "page": page
        ]
        
        let url = Constants.baseURLString + Endpoints.search.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func popularMoviesRequest(page: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let params = [
            "page": page
        ]
        
        let url = Constants.baseURLString + Endpoints.popular.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func movieDetailRequest(movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseURLString + Endpoints.detail.rawValue + "\(movieID)"
        
        baseRequest(url: url, completion: completion)
    }
    
    func movieGenresRequest(params: Parameters, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseURLString + Endpoints.genres.rawValue
        
        baseRequest(url: url, params: params, completion: completion)
    }
}
