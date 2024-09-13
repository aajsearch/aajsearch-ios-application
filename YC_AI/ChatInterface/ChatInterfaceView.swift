import UIKit

class ChatInterfaceView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tbl_chatShow: UITableView!
    @IBOutlet weak var txt_messageType: UITextField!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var lbl_agentDescription: UILabel!
    @IBOutlet weak var vw_messageType: UIView!
    @IBOutlet weak var btn_userProfile: UIButton!
    @IBOutlet weak var btn_more: UIButton!
    @IBOutlet weak var vw_stepbar: UIView!
    
    var agentID: String?
    var agentName: String?
    var agentImageURL: String?
    
    var messages: [(String, Bool)] = []
    var selectedTopics: [TopicModel] = []
    var chatHistory: [ChatModel] = []
    var stepProgress: Int = 0

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMessagesFromStorage()
        
        lbl_agentDescription.text = "\(agentName ?? "Agent")"
        
        setupStepBar()
        checkForStoredMessages()
    }

    // MARK: - Setup Methods
    func setupTableView() {
        tbl_chatShow.delegate = self
        tbl_chatShow.dataSource = self
        tbl_chatShow.register(UINib(nibName: "UserMessageTVC", bundle: nil), forCellReuseIdentifier: "UserMessageTVC")
        tbl_chatShow.register(UINib(nibName: "AgentMessageTVC", bundle: nil), forCellReuseIdentifier: "AgentMessageTVC")
        tbl_chatShow.separatorStyle = .none
        
        tbl_chatShow.transform = CGAffineTransform(scaleX: 1, y: -1)
        tbl_chatShow.rowHeight = UITableView.automaticDimension // Auto calculate row height
        tbl_chatShow.estimatedRowHeight = 44 // Set an estimated row height
    }
    
    // MARK: - Button Actions
    @IBAction func clk_send(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.insert((messageText, true), at: 0)
            saveMessagesToStorage()
            tbl_chatShow.reloadData()
            scrollToTop()
            respondToMessage(messageText: messageText)
            txt_messageType.text = ""

            lbl_agentDescription.isHidden = true
        }
    }
    
    
    @IBAction func clk_more(_ sender: Any) {
        let chatHistoryVC = ChatHistoryVC(nibName: "ChatHistoryVC", bundle: nil)
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    
    @IBAction func clk_back(_ sender: Any) {
        let chatHistoryVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    
    @IBAction func clk_profile(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Chat Logic
    func respondToMessage(messageText: String) {
        let lowercasedMessage = messageText.lowercased()

        if let possibleResponses = mockResponses[lowercasedMessage] {
            let response = possibleResponses.randomElement() ?? "I'm not sure how to respond to that."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.messages.insert((response, false), at: 0)
                self.saveMessagesToStorage()
                self.tbl_chatShow.reloadData()
                self.scrollToTop()
                self.updateStepProgress(step: min(self.stepProgress + 1, 5))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.messages.insert(("I'm sorry, I don't understand.", false), at: 0)
                self.saveMessagesToStorage()
                self.tbl_chatShow.reloadData()
                self.scrollToTop()
            }
        }
    }

    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tbl_chatShow.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    // MARK: - Message Persistence
    func saveMessagesToStorage() {
        let savedMessages = messages.map { [$0.0, $0.1 ? "user" : "agent"] }
        UserDefaults.standard.set(savedMessages, forKey: "savedChatMessages")
    }

    func loadMessagesFromStorage() {
        if let savedMessages = UserDefaults.standard.array(forKey: "savedChatMessages") as? [[String]] {
            messages = savedMessages.map { ($0[0], $0[1] == "user") }
            tbl_chatShow.reloadData()
        }
    }
    
    func checkForStoredMessages() {
        if !messages.isEmpty {
            lbl_agentDescription.isHidden = true
        }
    }
}

// MARK: - TableView DataSource & Delegate
extension ChatInterfaceView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageTVC", for: indexPath) as! UserMessageTVC
            cell.lbl_Message.text = message.0
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentMessageTVC", for: indexPath) as! AgentMessageTVC
            cell.lbl_Message.text = message.0
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        }
    }
}

extension ChatInterfaceView {
    
    // Setup the progress bar with steps
    func setupStepBar() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        let numberOfSteps = 7
        for index in 0..<numberOfSteps {
            let stepImageView = UIImageView()
            stepImageView.translatesAutoresizingMaskIntoConstraints = false
            stepImageView.contentMode = .scaleAspectFit
            
            if index % 2 == 0 {
                let imageName = index < stepProgress ? "circle_fill" : "circle"
                stepImageView.image = UIImage(named: imageName)
                stepImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                stepImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            } else {
                let imageName = index < stepProgress ? "rectangle_fill" : "rectangle"
                stepImageView.image = UIImage(named: imageName)
                stepImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                stepImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            }
            
            stackView.addArrangedSubview(stepImageView)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        vw_stepbar.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: vw_stepbar.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: vw_stepbar.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: vw_stepbar.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: vw_stepbar.bottomAnchor)
        ])
    }
    
    // Update the step progress based on current step
    func updateStepProgress(step: Int) {
        stepProgress = step
        if let stackView = vw_stepbar.subviews.first as? UIStackView {
            for (index, view) in stackView.arrangedSubviews.enumerated() {
                if let imageView = view as? UIImageView {
                    if index % 2 == 0 {
                        // Update circle images
                        imageView.image = UIImage(named: index < stepProgress ? "circle_fill" : "circle")
                    } else {
                        // Update rectangle images
                        imageView.image = UIImage(named: index < stepProgress ? "rectangle_fill" : "rectangle")
                    }
                }
            }
        }
    }
}
