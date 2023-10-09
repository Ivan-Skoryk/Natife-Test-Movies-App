//
//  MoviesSceneBuilder.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MoviesSceneBuilder {
    static func createScene() -> MoviesViewController {
        let moviesProvider = MovieProvider()
        let viewModel = MoviesListViewModel(moviesProvider: moviesProvider)
        let router = MoviesListRouter()
        let viewController = MoviesViewController()
        router.viewController = viewController
        viewModel.router = router
        viewController.viewModel = viewModel
        return viewController
    }
}
