//
//  MovieDetailSceneBuilder.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MovieDetailSceneBuilder {
    static func createScene(with movieDetail: MovieDetail) -> MovieDetailViewController {
        let viewModel = MovieDetailViewModel(movieDetail: movieDetail)
        let router = MovieDetailRouter()
        let viewController = MovieDetailViewController()
        
        router.viewController = viewController
        viewModel.router = router
        viewController.viewModel = viewModel
        
        return viewController
    }
}
