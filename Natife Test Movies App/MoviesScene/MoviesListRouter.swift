//
//  MoviesListRouter.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import UIKit

protocol MoviesListRouterProtocol {
    func navigateToMovieDetails(movieDetail: MovieDetail)
    func presentError(_ error: Error, onDismiss: @escaping (() -> Void))
}

final class MoviesListRouter {
    var viewController: UIViewController?
}

extension MoviesListRouter: MoviesListRouterProtocol {
    func navigateToMovieDetails(movieDetail: MovieDetail) {
        let vc = MovieDetailSceneBuilder.createScene(with: movieDetail)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentError(_ error: Error, onDismiss: @escaping (() -> Void)) {
        let description = error.localizedDescription
        
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            onDismiss()
        }
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
