//
//  RateMovieViewController.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

final class RateMovieViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var posterView: PosterView!
    @IBOutlet private weak var summaryLbl: UILabel!
    @IBOutlet private weak var rateButton: CustomButton!
    var presenter: RateMoviPresenter?
    private var dataSource: MovieDataCellProtocol?
    
    deinit { print("Deinitialized: \(String(describing: self))") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        if let imageUrl = dataSource?.backdrop_path {
            presenter?.startFetchingBackdrop(url: imageUrl)
        }
    }
    
    private func setUpUI()  {
        navigationItem.title = "Movie Summary"
        navigationController?.navigationBar.tintColor = .color10
        summaryLbl.text = dataSource?.overview
        setUpPosterView()
        setUpRateBtn()
    }
    
    private func setUpPosterView() {
        guard let dataSource = dataSource else { return }
        posterView.configure(movie: dataSource, hideRating: true, bubblesColor: .color10)
        posterView.backgroundColor = .black.withAlphaComponent(0.3)
        posterView.layer.cornerRadius = 20
        posterView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setUpRateBtn() {
        let btnModel = CustomButtonModel(title: "Rate Movie",
                                         unselectediIcon: UIImage(systemName: "star.fill")?.withTintColor(.color7, renderingMode: .alwaysOriginal),
                                         selectediIcon:  UIImage(systemName: "star.fill")?.withTintColor(.color2, renderingMode: .alwaysOriginal))
        rateButton.configure(model: btnModel)
        rateButton.semanticContentAttribute = .forceRightToLeft
    }
    
    func loadData(movie: MovieDataCellProtocol) {
        dataSource = movie
    }
    
    @IBAction func tappedBtn(_ sender: Any) {
        let customAlert = CustomAlert()
        customAlert.alertTitle = "Thank you"
        customAlert.alertMessage = "We have received your review"
        customAlert.delegate = self
        customAlert.show()
    }
    
    func updateBackdropImage(image: UIImage?){
        imageView.image = image
    }
    
    func failedToUpdateBackdropt(error: Error) {
        imageView.image = UIImage(systemName: "exclamationmark.triangle")
    }
    
}

extension RateMovieViewController: CustomAlertDelegate {
   
    func okButtonPressed(_ alert: CustomAlert) {}
    
}
