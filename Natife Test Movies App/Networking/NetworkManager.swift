//
//  NetworkManager.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation
import Alamofire

final class NetworkManager {
    static var shared = NetworkManager()
    
    enum Constants {
        static let baseURLString = "https://api.themoviedb.org/3/"
        static let baseImageStorageURL = "https://image.tmdb.org/t/p"
    }
    
    private let baseHeaders: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMDc0NTNiNmM4MzA3MWY1ODc1MWY0NTE3OTJlYzMxMSIsInN1YiI6IjY1MjJhOWZjMDcyMTY2MDBhY2I4ZjkyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9Q0Hs_dyRT-Xh6wMBjXLBbp6O9BUm9NkiuuFVooOq2k"
    ]
    
    let reachability = NetworkReachabilityManager.default
    
    func baseRequest(
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

func decodeData<T: Codable>(of type: T.Type, from result: Result<Data, Error>, completion: @escaping ((Result<T, Error>) -> Void)) {
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
