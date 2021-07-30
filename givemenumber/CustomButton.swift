//
//  iTrustButton.swift
//  iTrustPRO
//
//  Created by Anand on 11/09/18.
//  Copyright © 2018 iTrust Concierge. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    var activityIndicator: UIActivityIndicatorView!
    var originalButtonText: String?

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            layer.borderWidth = cornerRadius
        }
    }
    override func draw(_ rect: CGRect) {

        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        self.clipsToBounds = true
        //addShadow()

    }

    func addShadow(shadowColor: CGColor = UIColor.gray.cgColor,
                   shadowOffset: CGSize = CGSize(width: -5.0, height: 5.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 5.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius

    }

    func clearBg(){
        backgroundColor = UIColor.clear
    }

    func btnDisabled()
    {
        backgroundColor = UIColor.lightGray
        self.isEnabled = false
    }
    func btnEnabled()
    {
        backgroundColor = UIColor(red: 0/255.0, green: 193.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        self.isEnabled = true

    }
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)

        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        if activityIndicator != nil
        {
            activityIndicator.stopAnimating()
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}

