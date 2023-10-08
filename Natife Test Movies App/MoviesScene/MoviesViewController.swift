//
//  MoviesViewController.swift
//  Natife Test Movies App
//
//  Created by Ivan Skoryk on 07.10.2023.
//

import UIKit

final class MoviesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        reloadData()
    }
    
    private func setupViews() {
        setupTapGesture()
        setupTableView()
        setupRightNavigationItem()
        title = "Popular Movies"
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleViewTap() {
        view.endEditing(true)
    }
    
    private func setupTableView() {
        tableView.addSubview(refreshControl)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        
        tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        
        tableView.rowHeight = 3.0 * (UIScreen.main.bounds.width) / 4.0
    }
    
    @objc private func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    private func setupRightNavigationItem() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortActionSheet), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: button)
        NSLayoutConstraint.activate([
            item.customView!.widthAnchor.constraint(equalToConstant: 32),
            item.customView!.heightAnchor.constraint(equalToConstant: 32)
        ])
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func sortActionSheet() {
        let alert = UIAlertController(title: nil, message: "Sorting Options", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "By Name", style: .default))
        alert.addAction(UIAlertAction(title: "By Year", style: .default))
        alert.addAction(UIAlertAction(title: "By Rating", style: .default))
        alert.addAction(UIAlertAction(title: "By Genre", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let action = UIAlertAction(title: "action", style: .default)
        action.setValue(true, forKey: "checked")
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
