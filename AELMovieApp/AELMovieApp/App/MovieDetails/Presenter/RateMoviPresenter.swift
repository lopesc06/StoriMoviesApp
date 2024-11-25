//
//  RateMoviPresenter.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

final class RateMoviPresenter {
    
    weak var view: RateMovieViewController?
    var interactor: RateMovieInteractor?
    var router: RateMovieRouter?
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    //view to presenter
    func startFetchingBackdrop(url: String) {
        interactor?.download(url: url)
    }
    
    //interactor to presenter
    func didFinishFetchingBackdrop(result: Result<UIImage, Error>) {
        switch result {
            case .success(let image):
                view?.updateBackdropImage(image: image)
            case .failure(let error):
                view?.failedToUpdateBackdropt(error: error)
        }
    }
    
}
