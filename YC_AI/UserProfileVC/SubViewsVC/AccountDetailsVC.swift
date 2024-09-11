//
//  AccountDetailsVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 04/09/24.
//

import UIKit

class AccountDetailsVC: UIViewController {
    
    @IBOutlet weak var img_profileImage: UIImageView!
    @IBOutlet weak var btn_camaraImage: UIButton!
    @IBOutlet weak var txt_Name: FloatingLabelTextField!
    @IBOutlet weak var txt_subTitle: FloatingLabelTextField!
    @IBOutlet weak var txt_contactNo: FloatingLabelTextField!
    @IBOutlet weak var txt_email: FloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img_profileImage.layer.cornerRadius = 60
        img_profileImage.layer.masksToBounds = true
    }

    @IBAction func clk_Opncamara(_ sender: Any) {
        
    }
    
}
