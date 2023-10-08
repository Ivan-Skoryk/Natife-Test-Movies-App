//
//  MoviesTableViewCell.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 08.10.2023.
//

import UIKit

final class MoviesTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
//    @IBOutlet private weak var imageViewWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
    private func setupImageView() {
        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 20
        posterImageView.layer.shadowRadius = 10
        posterImageView.layer.shadowOpacity = 0.6
        posterImageView.clipsToBounds = false
    }
}
