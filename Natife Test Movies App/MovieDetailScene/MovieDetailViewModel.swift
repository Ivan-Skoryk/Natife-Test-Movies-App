//
//  MovieDetailViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MovieDetailViewModelProtocol {
    var movieDetail: MovieDetail { get }
    
    func pop()
    func navigateToFullscreenPosterImage()
}

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    var router: MovieDetailRouterProtocol!
    
    private(set) var movieDetail: MovieDetail
    
    init(movieDetail: MovieDetail) {
        self.movieDetail = movieDetail
    }
    
    func pop() {
        router.pop()
    }
    
    func navigateToFullscreenPosterImage() {
        router.navigateToFullscreenPosterImage(imageURLString: movieDetail.posterImageURLString)
    }
}
