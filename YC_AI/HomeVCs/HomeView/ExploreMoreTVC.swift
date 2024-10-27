//
//  ExploreMoreTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 13/10/24.
//

import UIKit

class ExploreMoreTVC: UITableViewCell {
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageview.layer.cornerRadius = 12
        imageview.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
