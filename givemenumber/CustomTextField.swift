//
//  iTrustTextField.swift
//  SuitePaws
//
//  Created by Anand on 22/05/19.
//  Copyright © 2019 iTrust Concierge. All rights reserved.
//

import UIKit
@IBDesignable open class CustomTextField: TextFieldEffects {
    /**
     The color of the border when it has no content.

     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    private var __maxLengths = [UITextField: Int]()

    @IBInspectable dynamic open var borderInactiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var leftPadding: CGFloat = 10{
        didSet {
            updateView()
        }
    }
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var color: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    /**
     The color of the border when it has content.

     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderActiveColor: UIColor? {
        didSet {
            updateBorder()
        }
    }

    /**
     The color of the placeholder text.

     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }

    /**
     The scale of the placeholder font.

     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 1.0 {
        didSet {
            updatePlaceholder()
        }
    }

    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }

    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 2, inactive: 0.5)
    private let placeholderInsets = CGPoint(x: 10, y: 6)
    private let textFieldInsets = CGPoint(x: 10, y: 12)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    private var activePlaceholderPoint: CGPoint = CGPoint.zero

    // MARK: - TextFieldEffects

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            let view = UIView(frame : CGRect(x: 0, y: 0, width: 45, height: 50))
            view.addSubview(imageView)
            leftView = view
        }
        else if leftPadding > 0
        {
            leftViewMode = UITextField.ViewMode.always
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
            leftView = paddingView
        }
        else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }


        if let image = rightImage{
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 10, width: 15, height: 25))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            let view = UIView(frame : CGRect(x: 0, y: 10, width: 30, height: 30))
            view.addSubview(imageView)
            rightView = view
        }
        else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }

    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))

        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(UIFont.init(name: "Avenir-Light", size: 14.0)!)

        updateBorder()
        updatePlaceholder()

        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
        addSubview(placeholderLabel)
    }

    override open func animateViewsForTextEntry() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
                self.placeholderLabel.frame.origin = CGPoint(x: 10, y: self.placeholderLabel.frame.origin.y)
                self.placeholderLabel.font = self.placeholderFontFromFont(UIFont.init(name: "Avenir-Light", size: 14.0)!)
                self.placeholderLabel.alpha = 0
            }), completion: { _ in
                self.animationCompletionHandler?(.textEntry)
            })
        }

        layoutPlaceholderInTextRect()
        placeholderLabel.frame.origin = activePlaceholderPoint

        UIView.animate(withDuration: 0.4, animations: {
            self.placeholderLabel.alpha = 1.0
        })

        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: true)
    }

    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.font = self.placeholderFontFromFont(UIFont.init(name: "Avenir-Light", size: 14.0)!)
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })

            activeBorderLayer.frame = self.rectForBorder(self.borderThickness.active, isFilled: false)
        }
    }

    // MARK: - Private

    private func updateBorder() {
        inactiveBorderLayer.frame = rectForBorder(borderThickness.inactive, isFilled: !isFirstResponder)
        inactiveBorderLayer.backgroundColor = borderInactiveColor?.cgColor

        activeBorderLayer.frame = rectForBorder(borderThickness.active, isFilled: isFirstResponder)
        activeBorderLayer.backgroundColor = borderActiveColor?.cgColor
    }

    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()

        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }

    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }

    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }

    private func layoutPlaceholderInTextRect() {
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.height/2,
                                        width: placeholderLabel.bounds.width, height: placeholderLabel.bounds.height)
        activePlaceholderPoint = CGPoint(x: placeholderLabel.frame.origin.x, y: placeholderLabel.frame.origin.y - placeholderLabel.frame.size.height - placeholderInsets.y)

    }

    // MARK: - Overrides

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }

}
extension String {
    /**
     true if self contains characters.
     */
    var isNotEmpty: Bool {
        return !isEmpty
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}


/**
 A TextFieldEffects object is a control that displays editable text and contains the boilerplates to setup unique animations for text entry and display. You typically use this class the same way you use UITextField.
 */
open class TextFieldEffects : UITextField {
    /**
     The type of animation a TextFieldEffect can perform.

     - TextEntry: animation that takes effect when the textfield has focus.
     - TextDisplay: animation that takes effect when the textfield loses focus.
     */
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }

    /**
     Closure executed when an animation has been completed.
     */
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()

    /**
     UILabel that holds all the placeholder information
     */
    public let placeholderLabel = UILabel()

    public let bottomLabel = UILabel()

    /**
     Creates all the animations that are used to leave the textfield in the "entering text" state.
     */
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }

    /**
     Creates all the animations that are used to leave the textfield in the "display input text" state.
     */
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }

    /**
     The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    open var animationCompletionHandler: AnimationCompletionHandler?

    /**
     Draws the receiver’s image within the passed-in rectangle.

     - parameter rect:    The portion of the view’s bounds that needs to be updated.
     */
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }

    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }

    // MARK: - Overrides

    override open func draw(_ rect: CGRect) {
        // FIXME: Short-circuit if the view is currently selected. iOS 11 introduced
        // a setNeedsDisplay when you focus on a textfield, calling this method again
        // and messing up some of the effects due to the logic contained inside these
        // methods.
        // This is just a "quick fix", something better needs to come along.
        guard isFirstResponder == false else { return }
        drawViewsForRect(rect)
    }

    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }

    override open var text: String? {
        didSet {
            if let text = text, text.isNotEmpty || isFirstResponder {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }

    // MARK: - UITextField Observing

    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)

            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }

    /**
     The textfield has started an editing session.
     */
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }

    /**
     The textfield has ended an editing session.
     */
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }

    // MARK: - Interface Builder

    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}


