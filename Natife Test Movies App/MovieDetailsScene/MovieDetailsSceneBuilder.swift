//
//  MovieDetailsSceneBuilder.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

final class MovieDetailsSceneBuilder {
    static func createScene(with movieDetail: MovieDetails) -> MovieDetailsViewController {
        let detailsProvider = MovieDetailsProvider(networkManager: NetworkManager.shared)
        let viewModel = MovieDetailsViewModel(movieDetails: movieDetail)
        viewModel.movieDetailsProvider = detailsProvider
        let router = MovieDetailsRouter()
        let viewController = MovieDetailsViewController()
        
        router.viewController = viewController
        viewModel.router = router
        viewController.viewModel = viewModel
        
        return viewController
    }
}
