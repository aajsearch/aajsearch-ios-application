//
//  Constants.swift
//  YC_AI
//
//  Created by Geeta Manek on 26/08/24.
//

import Foundation
import UIKit

let userDefault = UserDefaults.standard
let gm_rememberMe = "gm_rememberMe"


//MARK: custom TextFeild for edit Profile

class FloatingLabelTextField: UITextField, UIGestureRecognizerDelegate {

    private let floatingLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.isUserInteractionEnabled = false
        return label
    }()

    private var tapGesture: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(floatingLabel)
        borderStyle = .none
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(textChanged), for: .editingChanged)

        // Add tap gesture recognizer to the text field
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let labelHeight: CGFloat = bounds.height
        floatingLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight)
        tapGesture.delegate = self
    }

    @objc private func handleTap() {
        becomeFirstResponder()
    }

    @objc private func editingDidBegin() {
        animateFloatingLabel(shouldShow: true)
    }

    @objc private func editingDidEnd() {
        if text?.isEmpty ?? true {
            animateFloatingLabel(shouldShow: false)
        }
    }

    @objc private func textChanged() {
        if let text = text, !text.isEmpty {
            animateFloatingLabel(shouldShow: true)
        } else {
            animateFloatingLabel(shouldShow: false)
        }
    }

    private func animateFloatingLabel(shouldShow: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.alpha = shouldShow ? 1.0 : 0.0
            self.floatingLabel.frame.origin.y = shouldShow ? -self.floatingLabel.frame.height / 2 : 0
        }
    }

    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
        }
    }
}

// MARK: theme Button

class ThemeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        backgroundColor = UIColor.blue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 16)
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        if hexFormatted.count != 6{
            hexFormatted = "000000"
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
    
}
