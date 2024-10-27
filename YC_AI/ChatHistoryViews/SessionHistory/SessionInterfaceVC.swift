import UIKit

class SessionInterfaceVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbl_summrylabel: UILabel!
    @IBOutlet weak var lbl_summrylabelHeight: NSLayoutConstraint!
    @IBOutlet weak var img_arrow: UIImageView!
    
    @IBOutlet weak var tbl_keypoint: UITableView!
    @IBOutlet weak var Tbl_keypointHeight: NSLayoutConstraint!
    @IBOutlet weak var img_keyArrow: UIImageView!
    
    @IBOutlet weak var tbl_Action: UITableView!
    @IBOutlet weak var tbl_ActionHeight: NSLayoutConstraint!
    @IBOutlet weak var img_ActionArrow: UIImageView!
    
    var keypoint = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    ]
    
    var Action = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]
    
    var summary = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    
    var isSummaryVisible = false // Track visibility state
    var isKeypointsVisible = false // Track visibility state for keypoints
    var isActionVisible = false // Track visibility state for action points
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        setupSummaryLabel()
        lbl_summrylabel.text = summary
        lbl_summrylabelHeight.constant = 0 // Initially collapse the label
        setArrowDirection(isDown: true, imageView: img_arrow) // Arrow pointing down initially
        
        // Register custom cells
        tbl_keypoint.register(UINib(nibName: "KeypointTVC", bundle: nil), forCellReuseIdentifier: "KeypointTVC")
        tbl_Action.register(UINib(nibName: "ActionTVC", bundle: nil), forCellReuseIdentifier: "ActionTVC")
        
        // Set tableView delegates and dataSources
        tbl_keypoint.delegate = self
        tbl_keypoint.dataSource = self
        tbl_Action.delegate = self
        tbl_Action.dataSource = self
        
        // Initially hide the table views
        Tbl_keypointHeight.constant = 0
        tbl_ActionHeight.constant = 0
    }
    
    // MARK: - Table View DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_keypoint {
            return keypoint.count
        } else if tableView == tbl_Action {
            return Action.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_keypoint {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeypointTVC", for: indexPath) as! KeypointTVC
            cell.lbl_keypoint.text = keypoint[indexPath.row]
            return cell
        } else if tableView == tbl_Action {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTVC", for: indexPath) as! ActionTVC
            cell.lbl_Action.text = Action[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tbl_keypoint {
            print("Selected keypoint: \(keypoint[indexPath.row])")
        } else if tableView == tbl_Action {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActionTVC", for: indexPath) as! ActionTVC
            cell.img_selected.image = UIImage(named: "imageselected")
            print("Selected action: \(Action[indexPath.row])")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Toggle Summary
    
    @IBAction func clk_summaryButton(_ sender: Any) {
        toggleSectionVisibility(isVisible: isSummaryVisible, heightConstraint: lbl_summrylabelHeight, contentHeight: lbl_summrylabel.intrinsicContentSize.height, arrowImageView: img_arrow)
        isSummaryVisible.toggle()
    }
    
    // MARK: - Toggle Keypoints Table View
    
    @IBAction func clk_keypointButton(_ sender: Any) {
        let keypointContentHeight = tbl_keypoint.contentSize.height
        toggleSectionVisibility(isVisible: isKeypointsVisible, heightConstraint: Tbl_keypointHeight, contentHeight: keypointContentHeight, arrowImageView: img_keyArrow)
        isKeypointsVisible.toggle()
    }
    
    // MARK: - Toggle Actions Table View
    
    @IBAction func clk_ActionpointButton(_ sender: Any) {
        let actionContentHeight = tbl_Action.contentSize.height
        toggleSectionVisibility(isVisible: isActionVisible, heightConstraint: tbl_ActionHeight, contentHeight: actionContentHeight, arrowImageView: img_ActionArrow)
        isActionVisible.toggle()
    }
    
    // Helper function to toggle visibility with animation
    func toggleSectionVisibility(isVisible: Bool, heightConstraint: NSLayoutConstraint, contentHeight: CGFloat, arrowImageView: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            if isVisible {
                heightConstraint.constant = 0 // Collapse
            } else {
                heightConstraint.constant = contentHeight // Expand
            }
            self.view.layoutIfNeeded() // Update the layout with animation
        }
        setArrowDirection(isDown: isVisible, imageView: arrowImageView) // Adjust arrow direction
    }
    
    // Helper function to adjust the arrow direction (true = down, false = up)
    func setArrowDirection(isDown: Bool, imageView: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            if isDown {
                imageView.transform = CGAffineTransform.identity // Arrow points down
            } else {
                imageView.transform = CGAffineTransform(rotationAngle: .pi) // Arrow points up
            }
        }
    }
    
    // MARK: - Setup Summary Label
    
    func setupSummaryLabel() {
        lbl_summrylabel.numberOfLines = 0
        lbl_summrylabel.lineBreakMode = .byWordWrapping
        lbl_summrylabel.textColor = .black
        lbl_summrylabel.font = UIFont.systemFont(ofSize: 16)
    }
}
