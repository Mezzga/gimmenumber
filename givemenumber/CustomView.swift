//
//  iTrustView.swift
//  iTrustPRO
//
//  Created by Anand on 11/09/18.
//  Copyright © 2018 iTrust Concierge. All rights reserved.
//

import UIKit

class CustomView: UIView
{
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    func setBlackBorder()
    {
        layer.borderColor = defaultValidborderColor.cgColor
    }
    func setlighGrayColor()
    {
        layer.borderColor = defaultborderColor.cgColor
    }

    func setErrorColor()
    {
        layer.borderColor = errorMsgColor.cgColor

    }
    func isErrorColor() -> Bool{
        if self.layer.borderColor == errorMsgColor.cgColor
        {
            return true
        }
        return false
    }
}
