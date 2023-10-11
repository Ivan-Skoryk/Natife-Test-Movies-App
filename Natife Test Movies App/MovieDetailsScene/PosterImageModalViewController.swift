//
//  PosterImageModalViewController.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 10.10.2023.
//

import UIKit
import Kingfisher

final class PosterImageModalViewController: UIViewController {
    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var posterImageView: UIImageView!
    
    var posterImageURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    private func setupUI() {
        title = "Poster"
        setupBlur()
        setupCloseButton()
        setupPosterImageView()
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(blurEffectView, at: 0)
    }
    
    private func setupCloseButton() {
        navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        let item = UIBarButtonItem(systemItem: .close)
        item.target = self
        item.action = #selector(onCloseDidTap)
        navigationItem.leftBarButtonItem = item
    }
    
    @objc private func onCloseDidTap() {
        navigationController?.dismiss(animated: true)
    }
    
    private func setupPosterImageView() {
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 8.0
        
        guard let url = URL(string: posterImageURLString) else { return }
        posterImageView.kf.setImage(with: url)
    }
}

extension PosterImageModalViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return posterImageView
    }
}
