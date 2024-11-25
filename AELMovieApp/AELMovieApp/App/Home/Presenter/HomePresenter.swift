//
//  HomePresenter.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import UIKit

final class HomePresenter {
    
    weak var view: HomeViewController?
    var interactor: HomeInteractor?
    var router: HomeRouter?
    var dataSource = [MovieDataCellProtocol]()
    private var originalDataSource = [MovieDataCellProtocol]()
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    //viewToPresenter calls
    func startFetchingTopMovies() {
        interactor?.fetchMovies()
    }
    
    
    //presenterToInteractor Calls
    func fetchMoviewFinihed(result: Result<[MovieDataCellProtocol], Error>) {
        switch result {
            case .success(let response):
                originalDataSource.append(contentsOf: response)
                dataSource = originalDataSource
                view?.loadTopRatedMovies(data: dataSource)
                interactor?.fetchImages(forMovies: dataSource)
            case .failure(let error):
                view?.showError(error: error)
        }
    }
    
    func fetchImagesFinished(result: Result<(idx: Int, image: UIImage), Error>) {
        switch result {
            case .success(let result):
                originalDataSource[result.idx].posterUIImage = result.image
                dataSource[result.idx].posterUIImage = result.image
                view?.reloadMovieData(at: [IndexPath(row: result.idx, section: 0)])
            case .failure(let error):
                view?.showError(error: error)
        }
    }
    
    func searchMovie(text: String) {
        if text.isEmpty {
            dataSource = originalDataSource
        } else {
            dataSource = originalDataSource.filter { $0.title.lowercased().contains(text.lowercased()) }
        }
        view?.loadTopRatedMovies(data: dataSource)
    }
    
    
}
