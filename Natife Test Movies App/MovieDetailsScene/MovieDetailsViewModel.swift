//
//  MovieDetailsViewModel.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 09.10.2023.
//

import Foundation

protocol MovieDetailsViewModelProtocol {
    var movieDetails: MovieDetails { get }
    
    func getLatestTrailer(completion: @escaping ((Bool) -> Void))
    
    func pop()
    func navigateToFullscreenPosterImage()
    func navigateToTrailer()
}

final class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    var router: MovieDetailsRouterProtocol!
    var movieDetailsProvider: MovieDetailsProviderProtocol!
    
    private(set) var movieDetails: MovieDetails
    private var trailerURLString = ""
    
    init(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
    }
    
    func getLatestTrailer(completion: @escaping ((Bool) -> Void)) {
        movieDetailsProvider.getLatestTrailer(for: movieDetails.id) { [weak self] result in
            switch result {
            case .success(let url):
                guard let url = url else {
                    completion(false)
                    return
                }
                self?.trailerURLString = url
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func pop() {
        router.pop()
    }
    
    func navigateToFullscreenPosterImage() {
        router.navigateToFullscreenPosterImage(imageURLString: movieDetails.posterImageURLString)
    }
    
    func navigateToTrailer() {
        router.navigateToVideoPlayer(urlString: trailerURLString)
    }
}
