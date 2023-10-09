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
    
    func config(with movie: Movie) {
        if let url = URL(string: movie.backdropwImageURLString) {
            posterImageView.kf.setImage(with: url)
        }
        
        titleAndYearLabel.text = movie.title + ", " + movie.year
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        ratingsLabel.text = "Rating: \(movie.rating)"
    }
}
