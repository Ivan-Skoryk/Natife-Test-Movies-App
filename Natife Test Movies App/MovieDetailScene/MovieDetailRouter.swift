//
//  MovieDetailRouter.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import UIKit

protocol MovieDetailRouterProtocol {
    func navigateToFullscreenPosterImage(imageURLString: String)
    func navigateToVideoPlayer()
    func pop()
}

final class MovieDetailRouter {
    var viewController: UIViewController?
}

extension MovieDetailRouter: MovieDetailRouterProtocol {
    func navigateToFullscreenPosterImage(imageURLString: String) {
        let posterModalViewController = PosterImageModalViewController()
        posterModalViewController.posterImageURLString = imageURLString
        
        posterModalViewController.modalPresentationStyle = .popover
        
        viewController?.navigationController?.present(UINavigationController(rootViewController: posterModalViewController), animated: true)
    }
    
    func navigateToVideoPlayer() {
    }
    
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
