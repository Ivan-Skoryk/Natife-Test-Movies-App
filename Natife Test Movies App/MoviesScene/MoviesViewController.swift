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
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        
        label.text = "No Data Available"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .boldSystemFont(ofSize: 21)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -16.0)
        ])
        
        return label
    }()
    
    private var isLoading = false {
        didSet {
            if isLoading {
                setupActivityIndicator()
            } else {
                setupSortingButton()
            }
        }
    }
    private var refreshControl = UIRefreshControl()
    
    var viewModel: MoviesListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        reloadData()
    }
    
    private func setupViews() {
        setupTableView()
        setupSortingButton()
        setupSearchBar()
        setupNoDataLabel()
        title = "Popular Movies"
    }
    
    private func setupTableView() {
        tableView.insertSubview(refreshControl, at: 0)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshControlReload), for: .valueChanged)
        
        tableView.register(UINib(nibName: "MoviesTableViewCell", bundle: nil), forCellReuseIdentifier: "MoviesTableViewCell")
        
        tableView.rowHeight = 3.0 * (UIScreen.main.bounds.width) / 4.0
    }
    
    @objc private func refreshControlReload() {
        reloadData(reloadAll: true)
    }
    
    private func reloadData(reloadAll: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        viewModel.getMovies(reloadAll: reloadAll) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.isLoading = false
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
                self?.setupNoDataLabel()
            }
        }
    }
    
    private func setupNoDataLabel() {
        noDataLabel.isHidden = viewModel.movies.count != 0
    }
    
    private func setupActivityIndicator() {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        indicator.startAnimating()
        
        setupRightNavigationItem(customView: indicator)
    }
    
    private func setupSortingButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        button.setImage(UIImage(named: "sort"), for: .normal)
        button.addTarget(self, action: #selector(sortActionSheet), for: .touchUpInside)
        
        setupRightNavigationItem(customView: button)
    }
    
    private func setupRightNavigationItem(customView: UIView) {
        let item = UIBarButtonItem(customView: customView)
        NSLayoutConstraint.activate([
            item.customView!.widthAnchor.constraint(equalToConstant: 32),
            item.customView!.heightAnchor.constraint(equalToConstant: 32)
        ])
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func sortActionSheet() {
        let alert = UIAlertController(title: nil, message: "Sorting Options", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "By Name (A-Z)", style: .default))
        alert.addAction(UIAlertAction(title: "By Name (Z-A)", style: .default))
        alert.addAction(UIAlertAction(title: "By Year (Asc)", style: .default))
        alert.addAction(UIAlertAction(title: "By Year (Desc)", style: .default))
        alert.addAction(UIAlertAction(title: "By Rating (Asc)", style: .default))
        alert.addAction(UIAlertAction(title: "By Rating (Desc)", style: .default))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let action = UIAlertAction(title: "action", style: .default)
        action.setValue(true, forKey: "checked")
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
    private func setupSearchBar() {
        searchBar.showsCancelButton = true
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        cell.config(with: movie)
        
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToMovieDetail(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.movies.count - 1
        if indexPath.row == lastIndex && !isLoading {
            reloadData()
        }
    }
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.cancelSearch()
        setupNoDataLabel()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.setSearchString(string: searchBar.text ?? "")
        reloadData()
    }
}

