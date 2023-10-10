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
    
    @IBOutlet private weak var containerView: UIView!
    private var progressStackView = UIStackView()
    private var progressView = UIProgressView()
    
    var viewModel: MovieDetailViewModelProtocol!
    
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
        posterImageView.layer.shadowRadius = 10
        posterImageView.layer.shadowOpacity = 0.6
        posterImageView.clipsToBounds = false
        
        guard let url = URL(string: viewModel.movieDetail.posterImageURLString) else {
            setupNoImageAvailable()
            return
        }
        setupProgressView()
        
        posterImageView.kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] receivedSize, totalSize in
            self?.progressView.setProgress(Float(receivedSize) / Float(totalSize), animated: true)
        } completionHandler: { [weak self] _ in
            self?.progressStackView.subviews.forEach { $0.removeFromSuperview() }
            self?.progressStackView.removeFromSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView))
        posterImageView.addGestureRecognizer(tap)
        posterImageView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapOnImageView() {
        viewModel.navigateToFullscreenPosterImage()
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
    
    private func setupNoImageAvailable() {
        let label = UILabel()
        label.text = "No Image Available"
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 19)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -16.0)
        ])
    }
    
    private func setupProgressView() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        
        progressView = UIProgressView()
        
        progressStackView = UIStackView(arrangedSubviews: [activityIndicator, progressView])
        progressStackView.axis = .vertical
        progressStackView.spacing = 8.0
        
        progressStackView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(progressStackView)
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            progressStackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            progressStackView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: 16.0),
            progressStackView.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -16.0)
        ])
    }
    
    @IBAction private func trailerButtonDidTap(_ sender: UIButton) {
        print(#function)
    }
}
