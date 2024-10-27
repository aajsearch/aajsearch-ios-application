//
//  WelcomeVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 13/10/24.
//

import UIKit

class WelcomeVC: UIViewController {
    
    
    @IBOutlet weak var btn_createAcc: UIButton!
    
    
    @IBOutlet weak var btn_SkipLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_createAcc.layer.cornerRadius = 28
        btn_createAcc.layer.masksToBounds = true
        
        btn_SkipLogin.layer.cornerRadius = 28
        btn_SkipLogin.layer.masksToBounds = true
        
        btn_SkipLogin.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        btn_SkipLogin.layer.borderWidth = 1


    }

    @IBAction func btn_continueLogin(_ sender: Any) {
        let homeVC = LoginVC(nibName: "LoginVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
   
    @IBAction func clk_LoginSkip(_ sender: Any) {
        userDefault.set(true, forKey: gm_rememberMe)
        self.navigateToHomeVC()
    }
    
    func navigateToHomeVC() {
        let homeVC = OnboardingVC(nibName: "OnboardingVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}

