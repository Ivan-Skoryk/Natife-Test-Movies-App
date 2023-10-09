//
//  MovieDetailViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

class MovieDetailViewModel {
    var router: MovieDetailRouterProtocol!
    
    var movieDetail: MovieDetail
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
    
    func pop() {
        router.pop()
    }
}
