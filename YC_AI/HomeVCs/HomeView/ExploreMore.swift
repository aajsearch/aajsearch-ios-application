//
//  ExploreMore.swift
//  YC_AI
//
//  Created by Geeta Manek on 13/10/24.
//

import UIKit

class ExploreMore: UICollectionViewCell {
    
    
    @IBOutlet weak var imageview: UIImageView!
    
    
    @IBOutlet weak var lbl_agentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageview.layer.cornerRadius = imageview.frame.size.height/2
        imageview.layer.masksToBounds = true
    }

}
