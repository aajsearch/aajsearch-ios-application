import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 8.0
    @IBInspectable var bottomInset: CGFloat = 8.0
    @IBInspectable var leftInset: CGFloat = 8.0
    @IBInspectable var rightInset: CGFloat = 8.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
    
}

class UserTVC: UITableViewCell {

    var lbl_userMessage: PaddingLabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUserMessageLabel()
        lbl_userMessage.font = appThemeFont(size: 12, fontname: .notoRegular)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUserMessageLabel()
    }

    func setupUserMessageLabel() {
        lbl_userMessage = PaddingLabel()
        lbl_userMessage.translatesAutoresizingMaskIntoConstraints = false
        lbl_userMessage.textColor = .black
        lbl_userMessage.numberOfLines = 0
        lbl_userMessage.lineBreakMode = .byWordWrapping
        
        lbl_userMessage.backgroundColor = UIColor(hexString: "E7E7E7", alpha: 1)
        lbl_userMessage.layer.cornerRadius = 12
        lbl_userMessage.layer.masksToBounds = true

        contentView.addSubview(lbl_userMessage)

        NSLayoutConstraint.activate([
            lbl_userMessage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lbl_userMessage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            lbl_userMessage.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 80),
            lbl_userMessage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
