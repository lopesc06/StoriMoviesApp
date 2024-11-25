//
//  MovieInfoDetailsCollectionViewCell.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 21/11/24.
//

import UIKit

struct MovieInfoDetailModel {
    var descriptionText: String
}

final class MovieInfoDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var descriptionLbl: UILabel!
    private var view: UIView?
    required override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        guard let view = MovieInfoDetailsCollectionViewCell.nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.color4.cgColor
        view.layer.borderWidth = 2
        self.view = view
    }
    
    func configure(model: MovieInfoDetailModel, bubblesColor: UIColor = .color4) {
        descriptionLbl.text = model.descriptionText
        descriptionLbl.textColor = bubblesColor
        view?.layer.borderColor = bubblesColor.cgColor
    }
    
    
}
