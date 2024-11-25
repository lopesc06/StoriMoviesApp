//
//  HomeRouter.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import UIKit

final class HomeRouter {
    
    weak var entry: HomeViewController?
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    static func createmODule(usingNavigation: UINavigationController?) -> UIViewController {
        let view = HomeRouter.instantiateVC()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presentar = presenter
        router.entry = view
        return view
    }
    
    private static func instantiateVC() -> HomeViewController {
        let id = String(describing: HomeViewController.self)
        let storyboard = UIStoryboard(name: id, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: id) as! HomeViewController
    }
    
}
