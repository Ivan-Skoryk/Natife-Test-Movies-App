//
//  NetworkManager+MovieDetails.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

extension NetworkManager: MovieDetailNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void)) {
        let url = Constants.baseURLString + Endpoints.details.rawValue + "\(movieID)/videos"
        
        baseRequest(url: url, completion: completion)
    }
}
