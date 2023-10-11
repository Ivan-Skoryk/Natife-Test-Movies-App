//
//  MovieDetailsRouter.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import UIKit
import WebKit

protocol MovieDetailsRouterProtocol {
    func navigateToFullscreenPosterImage(imageURLString: String)
    func navigateToVideoPlayer(urlString: String)
    func pop()
}

final class MovieDetailsRouter {
    var viewController: UIViewController?
}

extension MovieDetailsRouter: MovieDetailsRouterProtocol {
    func navigateToFullscreenPosterImage(imageURLString: String) {
        let posterModalViewController = PosterImageModalViewController()
        posterModalViewController.posterImageURLString = imageURLString
        
        posterModalViewController.modalPresentationStyle = .popover
        
        viewController?.navigationController?.present(UINavigationController(rootViewController: posterModalViewController), animated: true)
    }
    
    func navigateToVideoPlayer(urlString: String) {
        let vc = WebViewController()
        vc.url = urlString
        vc.modalPresentationStyle = .popover
        
        viewController?.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func pop() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
