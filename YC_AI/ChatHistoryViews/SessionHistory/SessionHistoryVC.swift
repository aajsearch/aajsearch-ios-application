import UIKit

class SessionHistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_sessionname: UILabel!
    
    
    let sections = ["Today", "Previous 7 Days"]
    let items = [
        ["Presentation Image Assistance", "Finance Discussion Prompts", "Hello and Response", "Starting a 401k"],
        ["Presentation Image Assistance", "Finance Discussion Prompts", "Hello and Response", "Starting a 401k"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_sessionname.font = appThemeFont(size: 24, fontname: .notoSemiBold)
        
        // Register the cell
        tableView.register(UINib(nibName: "SessionHistoryTVC", bundle: nil), forCellReuseIdentifier: "SessionHistoryTVC")
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SessionHistoryTVC", for: indexPath) as? SessionHistoryTVC else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = items[indexPath.section][indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get selected item
        let selectedTitle = items[indexPath.section][indexPath.row]
        
        // Instantiate SessionSubHistoryVC from its XIB
        let sessionSubHistoryVC = SessionSubHistoryVC(nibName: "SessionSubHistoryVC", bundle: nil)
        sessionSubHistoryVC.selectedTitle = selectedTitle
        
        // Navigate to SessionSubHistoryVC
        navigationController?.pushViewController(sessionSubHistoryVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 // Standard row height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Custom height for section headers
    }
}
