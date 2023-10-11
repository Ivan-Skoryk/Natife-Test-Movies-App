//
//  MovieDetailNetworkManagerProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

protocol MovieDetailNetworkManagerProtocol {
    func getVideos(for movieID: Int, completion: @escaping ((Result<Data, Error>) -> Void))
}
