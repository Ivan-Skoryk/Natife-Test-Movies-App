//
//  MovieDetailRouter.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import UIKit

protocol MovieDetailRouterProtocol {
    func navigateToFullscreenPosterImage()
    func navigateToVideoPlayer()
    func pop()
}

class MovieDetailRouter {
    weak var viewController: UIViewController?
}

extension MovieDetailRouter: MovieDetailRouterProtocol {
    func navigateToFullscreenPosterImage() {
        
    }
    
    func navigateToVideoPlayer() {
        
    }
    
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
