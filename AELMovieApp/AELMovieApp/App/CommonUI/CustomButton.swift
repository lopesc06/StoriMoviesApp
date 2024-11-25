//
//  CustomButton.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 22/11/24.
//

import UIKit

struct CustomButtonModel {
    let title: String
    let buttonColor: UIColor = .color4
    let unselectedTitleColor: UIColor = .color7
    let selectedTitleColor: UIColor = .color2
    let unselectediIcon: UIImage?
    let selectediIcon: UIImage? 
}

final class CustomButton: UIButton {
    
    private var model = CustomButtonModel(title: "tap me", unselectediIcon: nil, selectediIcon: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Set properties
        setTitle(model.title, for: .normal)
        setTitleColor(model.unselectedTitleColor, for: .normal)
        setTitleColor(model.selectedTitleColor, for: .highlighted)
        setImage(model.unselectediIcon, for: .normal)
        setImage(model.selectediIcon, for: .highlighted)
        
        backgroundColor = model.buttonColor
        layer.cornerRadius = 20
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
    }
    
    func configure(model: CustomButtonModel) {
        self.model = model
        setupButton()
    }
    
}
