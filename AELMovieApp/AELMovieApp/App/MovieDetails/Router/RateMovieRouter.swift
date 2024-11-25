//
//  RateMovieRouter.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

class RateMovieRouter {
    
    weak var entry: UIViewController?
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    static func createModule(navigation: UINavigationController?, dataSource: MovieDataCellProtocol) -> UIViewController {

        let view = instantiateVC()
        let presenter = RateMoviPresenter()
        let interactor = RateMovieInteractor()
        let router = RateMovieRouter()
        
        view.loadData(movie: dataSource)
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.entry = view
        
        return view
    }
    
    private static func instantiateVC() -> RateMovieViewController {
        let id = String(describing: RateMovieViewController.self)
        return UIStoryboard(name: id, bundle: .main).instantiateViewController(withIdentifier: id) as! RateMovieViewController
    }
    
}
