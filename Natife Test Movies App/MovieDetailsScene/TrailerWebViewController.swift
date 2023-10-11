//
//  TrailerWebViewController.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 11.10.2023.
//

import UIKit
import WebKit

final class TrailerWebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupWebView()
    }
    
    private func setupUI() {
        title = "Trailer".localized
        setupBlur()
        setupCloseButton()
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
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
    
    private func setupWebView() {
        guard let url = URL(string: url) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
