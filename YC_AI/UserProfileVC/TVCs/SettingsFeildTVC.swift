//
//  SettingsFeildTVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 31/08/24.
//

import UIKit

class SettingsFeildTVC: UITableViewCell {
    
    
    @IBOutlet weak var ic_settingFeild: UIImageView!
    @IBOutlet weak var lbl_feildName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_feildName.font = appThemeFont(size: 16, fontname: .notoRegular)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


func appThemeFont(size : Float,fontname : themeFonts) -> UIFont {
    return UIFont(name: fontname.rawValue, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
}

enum themeFonts : String {
    case notoBold = "NotoSans-Bold"
    case notoSemiBold = "Montserrat-SemiBold"
    case notoMedium = "NotoSans-Medium"
    case notoRegular = "Montserrat-Regular"
    case notoLight = "NotoSans-Light"
}
