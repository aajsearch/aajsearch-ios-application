//
//  AgentMessageTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 25/08/24.
//

import UIKit

class AgentMessageTVC: UITableViewCell {

    @IBOutlet weak var lbl_Message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
