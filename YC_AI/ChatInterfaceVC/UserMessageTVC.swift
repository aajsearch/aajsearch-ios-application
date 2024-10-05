//
//  UserMessageTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 25/08/24.
//

import UIKit

class UserMessageTVC: UITableViewCell {

    @IBOutlet weak var lbl_Message: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_Message.numberOfLines = 0 // Allow multiple lines
        lbl_Message.lineBreakMode = .byWordWrapping // Wrap text to next line
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
