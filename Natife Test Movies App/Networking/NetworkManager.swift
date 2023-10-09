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
}

final class NetworkManager {
    static var shared = NetworkManager()
    
    enum Constants {
        static let baseURLString = "https://api.themoviedb.org/3/movie/"
        static let baseImageStorageURL = "https://image.tmdb.org/t/p"
        static let baseGenresURL = "https://api.themoviedb.org/3/genre/movie/list?language=en"
    }
    
    private let baseHeaders: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDc0NTNiNmM4MzA3MWY1ODc1MWY0NTE3OTJlYzMxMSIsInN1YiI6IjY1MjJhOWZjMDcyMTY2MDBhY2I4ZjkyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9Q0Hs_dyRT-Xh6wMBjXLBbp6O9BUm9NkiuuFVooOq2k"
      ]
    
    func baseRequest(
        url: String,
        params: Parameters? = nil,
        completion: @escaping ((Result<Data, Error>) -> Void)
    ) {
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
    
    func popularMoviesRequest(params: Parameters, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseURLString + "popular"
        
        baseRequest(url: url, params: params, completion: completion)
    }
    
    func movieDetailRequest(movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseURLString + "\(movieID)"
        
        baseRequest(url: url, completion: completion)
    }
    
    func movieGenresRequest(params: Parameters, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseGenresURL
        
        baseRequest(url: url, completion: completion)
    }
}
