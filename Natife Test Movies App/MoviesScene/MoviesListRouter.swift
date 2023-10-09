//
//  MoviesListRouter.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import UIKit

protocol MoviesListRouterProtocol {
    func navigateToMovieDetails(movieDetail: MovieDetail)
}

class MoviesListRouter {
    weak var viewController: UIViewController?
}

extension MoviesListRouter: MoviesListRouterProtocol {
    func navigateToMovieDetails(movieDetail: MovieDetail) {
        let vc = MovieDetailSceneBuilder.createScene(with: movieDetail)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
