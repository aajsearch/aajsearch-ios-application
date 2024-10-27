import UIKit

class ForyouCVC: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
    }
}
