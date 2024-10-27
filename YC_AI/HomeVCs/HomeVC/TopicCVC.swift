//
//  TopicCVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 25/08/24.
//

import UIKit

class TopicCVC: UICollectionViewCell {

    @IBOutlet weak var img_tpoic: UIImageView!
    @IBOutlet weak var lbl_topicName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        img_tpoic.layer.cornerRadius = 10

    }

}

