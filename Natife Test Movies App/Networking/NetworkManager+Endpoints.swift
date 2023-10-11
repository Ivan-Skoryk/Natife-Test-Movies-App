//
//  NetworkManager+Endpoints.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import Foundation

extension NetworkManager {
    enum Endpoints: String {
        case search = "search/movie"
        case popular = "movie/popular"
        case details = "movie/"
        case genres = "genre/movie/list"
    }
}
