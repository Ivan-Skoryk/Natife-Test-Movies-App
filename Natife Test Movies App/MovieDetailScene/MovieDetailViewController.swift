//
//  MovieDetailViewController.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 08.10.2023.
//

import UIKit
import Kingfisher

final class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var countryAndYearLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var movieTrailerButton: UIButton!
    @IBOutlet private weak var ratingsLabel: UILabel!
    @IBOutlet private weak var movieDescriptionLabel: UILabel!
    
    var viewModel: MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupPosterImageView()
        
        title = viewModel.movieDetail.title
        movieTitleLabel.text = viewModel.movieDetail.title
        
        let countries = viewModel.movieDetail.countries.joined(separator: ", ")
        countryAndYearLabel.text = countries + ", " + viewModel.movieDetail.year
        
        genresLabel.text = viewModel.movieDetail.genres.map { $0.name }.joined(separator: ", ")
        ratingsLabel.text = "Rating: \(String(format: "%.2f", viewModel.movieDetail.rating))/10"
        
        movieDescriptionLabel.text = viewModel.movieDetail.overview
    }
    
    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFit
        guard let url = URL(string: viewModel.movieDetail.posterImageURLString) else {
            return
        }
        posterImageView.kf.setImage(with: url)
    }
    
    private func setupNavigationBar() {
        let boldConfig = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 21), scale: .default)
        let icon = UIImage(systemName: "chevron.backward", withConfiguration: boldConfig)
        let item = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(pop))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc private func pop() {
        viewModel.pop()
    }
    
    @IBAction private func trailerButtonDidTap(_ sender: UIButton) {
        print(#function)
    }
}
