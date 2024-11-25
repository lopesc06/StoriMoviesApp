//
//  HomeViewController.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var scrollToTopBtn: UIButton!
    private var searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    var lastvisibleCellBeforeSearchIndexpath: IndexPath?
    private var shouldScrollToTop = false
    var presenter: HomePresenter?
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        presenter?.startFetchingTopMovies()
    }
    
    private func setUpUI() {
        setUpSearchBar()
        setUpNavigationBar()
        setUpTableview()
        setUpScrolToTopBtn()
    }
    
    private func setUpNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .color1
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationItem.title = "Top Movies"
        
    }
    
    private func setUpSearchBar() {
        searchController.searchBar.tintColor = .color5
        searchController.searchBar.searchTextField.backgroundColor = .color5
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    
    private func setUpTableview() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(TopMovieTableViewCell.self, forCellReuseIdentifier: TopMovieTableViewCell.identifier)
        moviesTableView.showsVerticalScrollIndicator = false
        moviesTableView.layer.cornerRadius = 20
        moviesTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        moviesTableView.addSubview(refreshControl)
    }
    
    private func setUpScrolToTopBtn() {
        scrollToTopBtn.layer.cornerRadius = 0.5 * scrollToTopBtn.frame.width
        scrollToTopBtn.layer.borderWidth = 1
        scrollToTopBtn.layer.borderColor = UIColor.color6.cgColor
        scrollToTopBtn.clipsToBounds = true
    }
    
    @IBAction func pressedBtn(_ sender: Any) {
        guard let dataSource = presenter?.dataSource, dataSource.count > 0 else { return }
        if shouldScrollToTop {
            moviesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        } else {
            let lastRow = moviesTableView.numberOfRows(inSection: 0) - 1
            moviesTableView.scrollToRow(at: IndexPath(row: lastRow, section: 0), at: .top, animated: true)
        }
        
    }
    
    @objc private func refresh(_ sender: AnyObject) {
        presenter?.startFetchingTopMovies()
    }
    
    func loadTopRatedMovies(data: [MovieProtocol]) {
        moviesTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func reloadMovieData(at: [IndexPath]) {
        moviesTableView.reloadRows(at: at, with: .fade)
    }
    
    func showError(error: Error) {
        switch error {
            case is URLError:
                let urlError = error as! URLError
                switch urlError.code {
                    case .cannotFindHost, .notConnectedToInternet:
                        showAlert(title: "Error", message: "No internet connection")
                    case .timedOut:
                        showAlert(title: "Timeout", message: "Service took to much time to respond")
                    default:
                        showAlert(title: "\(urlError.code)", message: error.localizedDescription)
                }
            default:
                showAlert(title: "Ooops!!!", message: "Something went wrong :(")
        }
        refreshControl.endRefreshing()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


extension HomeViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        presenter?.searchMovie(text: searchText)
        if searchText.isEmpty, let lastvisibleCellIndexpath = lastvisibleCellBeforeSearchIndexpath {
            moviesTableView.scrollToRow(at: lastvisibleCellIndexpath, at: .top, animated: false)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        lastvisibleCellBeforeSearchIndexpath = moviesTableView.indexPathsForVisibleRows?.first
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopMovieTableViewCell.identifier, for: indexPath) as? TopMovieTableViewCell,
              let movie = presenter?.dataSource[indexPath.item] else { return UITableViewCell() }
        cell.configure(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.3
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let totalItems = presenter?.dataSource.count else { return }
        if indexPath.row == totalItems - 1, searchController.searchBar.text == "" {
            presenter?.startFetchingTopMovies()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard moviesTableView.visibleCells.count > 0 else { return }
        let firstCellIndexPath = IndexPath(row: 0, section: 0)
        if let visibleRows = moviesTableView.indexPathsForVisibleRows, visibleRows.contains(firstCellIndexPath) {
            scrollToTopBtn.setImage(UIImage(systemName: "arrow.down"), for: .normal)
            shouldScrollToTop = false
        } else {
            scrollToTopBtn.setImage(UIImage(systemName: "arrow.up"), for: .normal)
            shouldScrollToTop = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = presenter?.dataSource[indexPath.row] else { return }
        let vc = RateMovieRouter.createModule(navigation: navigationController, dataSource: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
