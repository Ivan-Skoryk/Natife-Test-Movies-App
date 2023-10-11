//
//  MoviesTableViewCell.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 08.10.2023.
//

import UIKit
import Kingfisher

final class MoviesTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterContainer: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleAndYearLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var ratingsLabel: UILabel!
    
    private var progressStackView = UIStackView()
    private var progressView = UIProgressView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
        setupLabelsShadow()
        
        posterImageView.image = nil
        titleAndYearLabel.text = nil
        genresLabel.text = nil
        ratingsLabel.text = nil
    }
    
    private func setupImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 20
        
        posterContainer.layer.cornerRadius = 20
        posterContainer.layer.shadowRadius = 10
        posterContainer.layer.shadowOpacity = 0.6
        posterContainer.clipsToBounds = false
    }
    
    private func setupLabelsShadow() {
        [titleAndYearLabel, genresLabel, ratingsLabel].forEach {
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowRadius = 3.0
            $0.layer.shadowOpacity = 1.0
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.masksToBounds = false
        }
    }
    
    private func setupNoImageAvailable() {
        let label = UILabel()
        label.text = "No Image Available"
        label.textColor = .lightGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 19)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        posterContainer.insertSubview(label, at: 0)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: posterContainer.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: posterContainer.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: posterContainer.trailingAnchor, constant: -16.0)
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
        
        posterContainer.insertSubview(progressStackView, at: 0)
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 10),
            
            progressStackView.centerYAnchor.constraint(equalTo: posterContainer.centerYAnchor),
            progressStackView.leadingAnchor.constraint(equalTo: posterContainer.leadingAnchor, constant: 16.0),
            progressStackView.trailingAnchor.constraint(equalTo: posterContainer.trailingAnchor, constant: -16.0)
        ])
    }
    
    func config(with movie: Movie) {
        if let urlString = movie.backdropwImageURLString ?? movie.posterImageURLString,
           let url = URL(string: urlString) {
            setupProgressView()
            
            posterImageView.kf.setImage(with: url, placeholder: nil, options: nil) { [weak self] receivedSize, totalSize in
                self?.progressView.setProgress(Float(receivedSize) / Float(totalSize), animated: true)
            } completionHandler: { [weak self] _ in
                self?.progressStackView.subviews.forEach { $0.removeFromSuperview() }
                self?.progressStackView.removeFromSuperview()
            }
        } else {
            setupNoImageAvailable()
        }
        
        titleAndYearLabel.text = movie.title + ", " + movie.year
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        ratingsLabel.text = String(format: "Rating: %.1f", movie.rating)
    }
}
