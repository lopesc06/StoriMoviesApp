//
//  RateMovieInteractor.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import Foundation

final class RateMovieInteractor {
    
    weak var presenter: RateMoviPresenter?
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    func download(url: String) {
        ImageManager.callService(urlString: Constants.imageHost + url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let image):
                    presenter?.didFinishFetchingBackdrop(result: .success(image))
                case .failure(let error):
                    presenter?.didFinishFetchingBackdrop(result: .failure(error))
            }
            
        }
    }
    
}
