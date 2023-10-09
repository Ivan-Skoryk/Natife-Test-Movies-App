//
//  MoviesSceneBuilder.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MoviesSceneBuilder {
    static func createInstance() -> MoviesViewController {
        let moviesProvider = MovieProvider()
        let viewModel = MoviesListViewModel(moviesProvider: moviesProvider)
        let viewController = MoviesViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
