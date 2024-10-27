//
//  ActionTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 20/10/24.
//

import UIKit

class ActionTVC: UITableViewCell {
    
    
    @IBOutlet weak var img_selected: UIImageView!
    @IBOutlet weak var lbl_Action: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
