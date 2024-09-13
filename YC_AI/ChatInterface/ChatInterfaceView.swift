import UIKit

class ChatInterfaceView: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tbl_chatShow: UITableView!
    @IBOutlet weak var txt_messageType: UITextField!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var lbl_agentDescription: UILabel! // Label to show agent's description
    @IBOutlet weak var vw_messageType: UIView!
    @IBOutlet weak var btn_userProfile: UIButton!
    @IBOutlet weak var btn_more: UIButton!

    // Properties for agent details
    var agentID: String?
    var agentName: String?
    var agentImageURL: String?

    var messages: [(String, Bool)] = [] // Tuple to store messages (message, isUserMessage)
    var selectedTopics: [TopicModel] = []
    var chatHistory: [ChatModel] = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMessagesFromStorage() // Load stored messages

        // Set agent description or other details
        lbl_agentDescription.text = "\(agentName ?? "Agent")"
        
        // Hide agent description if there are stored messages
        checkForStoredMessages()
    }

    // MARK: - Setup Methods
    func setupTableView() {
        tbl_chatShow.delegate = self
        tbl_chatShow.dataSource = self
        tbl_chatShow.register(UINib(nibName: "UserMessageTVC", bundle: nil), forCellReuseIdentifier: "UserMessageTVC")
        tbl_chatShow.register(UINib(nibName: "AgentMessageTVC", bundle: nil), forCellReuseIdentifier: "AgentMessageTVC")
        tbl_chatShow.separatorStyle = .none
        
        // Invert the table view to start the chat from the bottom
        tbl_chatShow.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    // MARK: - Button Actions
    @IBAction func clk_profile(_ sender: Any) {
        let userProfileVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }

    @IBAction func clk_send(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.insert((messageText, true), at: 0) // Insert user message at the top (since table is inverted)
            saveMessagesToStorage() // Save the updated messages
            tbl_chatShow.reloadData() // Reload table view
            scrollToTop() // Scroll to the top of the table view
            respondToMessage(messageText: messageText) // Respond to the message
            txt_messageType.text = "" // Clear the text field

            // Hide lbl_agentDescription after the first message is sent
            lbl_agentDescription.isHidden = true
        }
    }

    @IBAction func btn_more(_ sender: Any) {
        let chatHistoryVC = ChatHistoryVC(nibName: "ChatHistoryVC", bundle: nil)
        chatHistoryVC.chatData = chatHistory
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }

    // MARK: - Chat Logic
    func respondToMessage(messageText: String) {
        let lowercasedMessage = messageText.lowercased()

        if let possibleResponses = mockResponses[lowercasedMessage] {
            let response = possibleResponses.randomElement() ?? "I'm not sure how to respond to that."
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.messages.insert((response, false), at: 0) // Insert agent's response at the top (since table is inverted)
                self.saveMessagesToStorage() // Save the updated messages
                self.tbl_chatShow.reloadData()
                self.scrollToTop()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.messages.insert(("I'm sorry, I don't understand.", false), at: 0) // Insert default response
                self.saveMessagesToStorage() // Save the updated messages
                self.tbl_chatShow.reloadData()
                self.scrollToTop()
            }
        }
    }

    // Scroll to the top of the chat (since the table is inverted)
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0) // First message
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
    
    // Check if there are stored messages and hide lbl_agentDescription if so
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
            cell.transform = CGAffineTransform(scaleX: 1, y: -1) // Invert the cell to align with the table inversion
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentMessageTVC", for: indexPath) as! AgentMessageTVC
            cell.lbl_Message.text = message.0
            cell.transform = CGAffineTransform(scaleX: 1, y: -1) // Invert the cell to align with the table inversion
            return cell
        }
    }
}
