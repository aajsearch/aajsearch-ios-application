import UIKit

class UserProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var image = ["ic_account","ic_privacy","ic_chat","ic_notification","ic_subscription"]
    var Name = ["Account","Privacy","chats","Notification","Subscription"]
    
    @IBOutlet weak var tbl_SettingsFeilds: UITableView!
    @IBOutlet weak var vw_Userdetail: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbl_SettingsFeilds.dataSource = self
        tbl_SettingsFeilds.delegate = self
        
        vw_Userdetail.layer.cornerRadius = 10
        vw_Userdetail.layer.masksToBounds = true
        tbl_SettingsFeilds.layer.cornerRadius = 10
        tbl_SettingsFeilds.layer.masksToBounds = true
        
        tbl_SettingsFeilds.register(UINib(nibName: "SettingsFeildTVC", bundle: nil), forCellReuseIdentifier: "SettingsFeildTVC")
    }
    
    
    @IBAction func clk_profileDetails(_ sender: Any) {
        let accountDetailsVC = AccountDetailsVC(nibName: "AccountDetailsVC", bundle: nil)
        self.navigationController?.pushViewController(accountDetailsVC, animated: true)
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return image.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsFeildTVC", for: indexPath) as? SettingsFeildTVC else {
            return UITableViewCell()
        }
        
        cell.ic_settingFeild.image = UIImage(named: image[indexPath.row])
        cell.lbl_feildName.text = Name[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedOption = Name[indexPath.row]
        
        switch selectedOption {
        case "Account":
            let accountDetailsVC = AccountDetailsVC(nibName: "AccountDetailsVC", bundle: nil)
            self.navigationController?.pushViewController(accountDetailsVC, animated: true)
            
        case "Privacy":
            let subscriptionVC = SubsCriptionVC(nibName: "SubsCriptionVC", bundle: nil)
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
            
        case "chats":
            let subscriptionVC = SubsCriptionVC(nibName: "SubsCriptionVC", bundle: nil)
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
            
        case "Notification":
            let subscriptionVC = SubsCriptionVC(nibName: "SubsCriptionVC", bundle: nil)
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
            
        case "Subscription":
            let subscriptionVC = SubsCriptionVC(nibName: "SubsCriptionVC", bundle: nil)
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
            
        default:
            print("No action for selected option: \(selectedOption)")
        }
    }
}
