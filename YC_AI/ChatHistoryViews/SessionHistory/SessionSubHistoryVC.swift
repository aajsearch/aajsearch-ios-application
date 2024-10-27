import UIKit

class SessionSubHistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lbl_sectionTitle: UILabel!
    @IBOutlet weak var tbl_subHistory: UITableView!
    
    let sessionTitles = [
        "Learn about dividends",
        "Lean about 401k",
        "Session 3",
        "Session 4",
        "Session 5" // Add more session titles as needed
    ]
    var selectedTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_sectionTitle.font = appThemeFont(size: 24, fontname: .notoSemiBold)
        
        lbl_sectionTitle.text = selectedTitle

        // Register the cell
        tbl_subHistory.register(UINib(nibName: "SessionSubHistoryTVC", bundle: nil), forCellReuseIdentifier: "SessionSubHistoryTVC")
        
        // Set delegates
        tbl_subHistory.delegate = self
        tbl_subHistory.dataSource = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SessionSubHistoryTVC", for: indexPath) as? SessionSubHistoryTVC else {
            return UITableViewCell()
        }
        
        // Set the session title for each cell
        cell.lbl_titleLabel.text = sessionTitles[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 // Customize as needed
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get selected item
        
        // Instantiate SessionSubHistoryVC from its XIB
        let sessionSubHistoryVC = SelSessionHistoryVC(nibName: "SelSessionHistoryVC", bundle: nil)
        
        navigationController?.pushViewController(sessionSubHistoryVC, animated: true)
    }
}
