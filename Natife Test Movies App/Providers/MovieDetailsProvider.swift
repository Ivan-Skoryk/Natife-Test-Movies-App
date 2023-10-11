//
//  MovieDetailsProvider.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

final class MovieDetailsProvider {
    private let networkManager: MovieDetailNetworkManagerProtocol!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.sssZ"
        
        return formatter
    }()
    
    init(networkManager: MovieDetailNetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

extension MovieDetailsProvider: MovieDetailsProviderProtocol {
    enum VideoType: String {
        case trailer = "Trailer"
    }
    
    enum VideoSite: String {
        case youtube = "YouTube"
    }
    
    private func handleVideosResponse(_ result: Result<MovieVideosDTO, Error>, completion: @escaping ((Result<String?, Error>) -> Void)) {
        switch result {
        case .success(let videos):
            let baseURL = "https://www.youtube.com/embed/"
            var latestKey = ""
            var latestDate = Date(timeIntervalSince1970: 0)
            
            for video in videos.results {
                guard video.type == VideoType.trailer.rawValue,
                      video.site == VideoSite.youtube.rawValue,
                      let date = dateFormatter.date(from: video.publishedAt)
                else { continue }
                
                if latestDate < date {
                    latestDate = date
                    latestKey = video.key
                }
            }
            
            let result = latestKey == "" ? nil : baseURL + latestKey
            completion(.success(result))
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func getLatestTrailer(for movieID: Int, completion: @escaping ((Result<String?, Error>) -> Void)) {
        networkManager.getVideos(for: movieID) { result in
            decodeData(of: MovieVideosDTO.self, from: result) { [weak self] result in
                self?.handleVideosResponse(result, completion: completion)
            }
        }
    }
}
