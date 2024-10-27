//
//  SessionSubHistoryTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 16/10/24.
//

import UIKit

class SessionSubHistoryTVC: UITableViewCell {
    
    
    @IBOutlet weak var lbl_titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_titleLabel.font = appThemeFont(size: 16, fontname: .notoRegular)
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
