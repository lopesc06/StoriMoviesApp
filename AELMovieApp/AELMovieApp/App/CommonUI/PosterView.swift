//
//  PosterView.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

final class PosterView: UIView {

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var moviesTitleLbl: UILabel!
    @IBOutlet private weak var rateLbl: UILabel!
    @IBOutlet private weak var numberOfRatesLbl: UILabel!
    @IBOutlet private weak var detailsCollectionView: UICollectionView!
    @IBOutlet private weak var ratingInfoStack: UIStackView!
    private var bubblesColor = UIColor.color4
    private var dataSource = [MovieInfoDetailModel]()
    private var movie: MovieDataCellProtocol?
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        guard let view = PosterView.nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        posterImageView.layer.cornerRadius = 12
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        detailsCollectionView.register(MovieInfoDetailsCollectionViewCell.self, forCellWithReuseIdentifier: MovieInfoDetailsCollectionViewCell.identifier)
        if let flowLayout = detailsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    func configure(movie: MovieDataCellProtocol, hideRating: Bool = false, bubblesColor: UIColor = .color4) {
        self.movie = movie
        self.bubblesColor = bubblesColor
        if let posterImage = movie.posterUIImage {
            posterImageView.image = posterImage
            posterImageView.contentMode = .scaleAspectFill
        } else {
            posterImageView.image = UIImage(systemName: "photo.artframe")
            posterImageView.contentMode = .scaleAspectFit
        }
        
        moviesTitleLbl.text = movie.title
        rateLbl.text = String(format: "%.2f", movie.vote_average)
        numberOfRatesLbl.text = "(\(movie.vote_count))"
        dataSource = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        if let releaseDate = movie.release_date, let date = dateFormatter.date(from: releaseDate)  {
            let year = calendar.component(.year, from: date)
            dataSource.append(MovieInfoDetailModel(descriptionText: "\(year)" ))
        }
        dataSource.append(MovieInfoDetailModel(descriptionText: movie.original_language))
        dataSource.append(MovieInfoDetailModel(descriptionText: "\(movie.original_title)"))
        detailsCollectionView.reloadData()
        if hideRating {
            ratingInfoStack.removeFromSuperview()
        }
    }
    
    
}



extension PosterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieInfoDetailsCollectionViewCell.identifier, for: indexPath) as? MovieInfoDetailsCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(model: dataSource[indexPath.row], bubblesColor: bubblesColor)
        return cell
    }
    
}

