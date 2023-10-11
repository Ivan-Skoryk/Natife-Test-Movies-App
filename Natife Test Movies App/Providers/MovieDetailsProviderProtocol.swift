//
//  MovieDetailsProviderProtocol.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

protocol MovieDetailsProviderProtocol {
    func getLatestTrailer(for movieID: Int, completion: @escaping ((Result<String?, Error>) -> Void))
}
