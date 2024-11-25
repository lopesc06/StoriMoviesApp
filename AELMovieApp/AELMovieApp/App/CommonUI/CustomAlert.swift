//
//  CustomAlert.swift
//  AELMovieApp
//
//  Created by Arturo Escutia Lopez on 24/11/24.
//

import UIKit

protocol CustomAlertDelegate: AnyObject {
    func okButtonPressed(_ alert: CustomAlert)
}

class CustomAlert: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    weak var delegate: CustomAlertDelegate?
    var alertTitle = ""
    var alertMessage = ""
    var okButtonTitle = "Ok"
    var statusImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.color2, renderingMode: .alwaysOriginal)
    
    init() {
        super.init(nibName: "CustomAlert", bundle: Bundle(for: CustomAlert.self))
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAlert()
    }
    
    func show() {
        UIApplication.shared.windows.first?.rootViewController?.present(self, animated: true, completion: nil)
    }
    
    func setupAlert() {
        titleLabel.text = alertTitle
        messageLabel.text = alertMessage
        statusImageView.image = statusImage
        okButton.setTitle(okButtonTitle, for: .normal)
        alertView.layer.cornerRadius = 20
    }
    
    @IBAction func actionOnOkButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.okButtonPressed(self)
    }
   
}
