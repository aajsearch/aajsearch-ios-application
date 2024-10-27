import UIKit
import GoogleSignIn
import FacebookLogin

class LoginVC: UIViewController {
    
    @IBOutlet weak var vw_AppleLogin: UIView!
    @IBOutlet weak var vw_GoogleLogin: UIView!
    
    @IBOutlet weak var vw_FacebookLogin: UIView!
    @IBOutlet weak var vw_LinkdinLogin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_AppleLogin.layer.cornerRadius = 28
        vw_AppleLogin.layer.masksToBounds = true
        vw_GoogleLogin.layer.cornerRadius = 28
        vw_GoogleLogin.layer.masksToBounds = true
        vw_FacebookLogin.layer.cornerRadius = 28
        vw_FacebookLogin.layer.masksToBounds = true
        vw_FacebookLogin.layer.borderColor = UIColor(hexString: "#0B6BCB").cgColor
        vw_FacebookLogin.layer.borderWidth = 1
        vw_LinkdinLogin.layer.cornerRadius = 28
        vw_LinkdinLogin.layer.masksToBounds = true
        vw_LinkdinLogin.layer.borderColor = UIColor(hexString: "#0B6BCB").cgColor
        vw_LinkdinLogin.layer.borderWidth = 1
       
       
    }
    
    @IBAction func clk_AppleLogin(_ sender: Any) {
    }
    
    @IBAction func clk_GoogleLogin(_ sender: Any) {
        googleLogin()
    }
    
    @IBAction func clk_FacebookLogin(_ sender: Any) {
        fbLogin()
    }
    
    func navigateToHomeVC() {
        let homeVC = OnboardingVC(nibName: "OnboardingVC", bundle: nil)
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
   
}

extension LoginVC {
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login.")
                return
            }
            userDefault.set(true, forKey: gm_rememberMe)
            self.navigateToHomeVC()
        }
    }
    
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Error during Google Sign-In: \(error.localizedDescription)")
                return
            }
            
            guard let user = signInResult?.user else { return }
            print("User signed in: \(user.profile?.name ?? "No Name")")
            
            userDefault.set(true, forKey: gm_rememberMe)
            self.navigateToHomeVC()
        }
    }
    
   
}
