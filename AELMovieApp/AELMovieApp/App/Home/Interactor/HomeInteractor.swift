//
//  HomeInteractor.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import Foundation

final class HomeInteractor {
    
    weak var presentar: HomePresenter?
    private var currentPage: Int = 1
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    func fetchMovies() {
        HttpNetworkManager.callService(endpoint: TopRatedListEndpoint(page: String(currentPage))) { [weak self] (result: Result<TopRatedListResponse, Error>) in
            switch result {
                case .success(let result):
                    let final = result.results.compactMap { return HomeViewMovieData(movie: $0) }
                    self?.presentar?.fetchMoviewFinihed(result: .success(final))
                    self?.currentPage += 1
                case .failure(let error):
                    self?.presentar?.fetchMoviewFinihed(result: .failure(error))
            }
        }
    }
    
    func fetchImages(forMovies: [MovieDataCellProtocol]) {
        
        for (idx, movie) in forMovies.enumerated() {
            guard movie.posterUIImage == nil, let urlString = movie.poster_path else { continue }
            ImageManager.callService(urlString: Constants.imageHost + urlString) { [weak self] result in
                switch result {
                    case .success(let image):
                        self?.presentar?.fetchImagesFinished(result: .success((idx, image)))
                    case .failure(let error):
                        self?.presentar?.fetchImagesFinished(result: .failure(error))
                }
                
            }
        }
    }
    
}
