import UIKit
import Alamofire
import ObjectMapper


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
    var conversationID: String? // Store conversation ID here
    
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

    
    
    // MARK: - Button Actions
    @IBAction func clk_send(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.insert((messageText, true), at: 0)
            saveMessagesToStorage()
            tbl_chatShow.reloadData()
            scrollToTop()
            sendMessage(messageText: messageText) // Handle the API call here
            txt_messageType.text = ""
            lbl_agentDescription.isHidden = true
        }
    }
    
    @IBAction func clk_more(_ sender: Any) {
        let chatHistoryVC = ChatHistoryVC(nibName: "ChatHistoryVC", bundle: nil)
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    @IBAction func clk_back(_ sender: Any) {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clk_profile(_ sender: Any) {
        let chatHistoryVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    // MARK: - Chat Logic
    func respondToMessage(messageText: String, agentResponse: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let response = agentResponse {
                self.messages.insert((response, false), at: 0)
            } else {
                self.messages.insert(("I'm sorry, I don't understand.", false), at: 0)
            }
            self.saveMessagesToStorage()
            self.tbl_chatShow.reloadData()
            self.scrollToTop()
            self.updateStepProgress(step: min(self.stepProgress + 1, 5))
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
    
    // MARK: - Setup Methods
    func setupTableView() {
        tbl_chatShow.delegate = self
        tbl_chatShow.dataSource = self
        tbl_chatShow.register(UINib(nibName: "UserMessageTVC", bundle: nil), forCellReuseIdentifier: "UserMessageTVC")
        tbl_chatShow.register(UINib(nibName: "AgentMessageTVC", bundle: nil), forCellReuseIdentifier: "AgentMessageTVC")
        tbl_chatShow.separatorStyle = .none
        
        tbl_chatShow.transform = CGAffineTransform(scaleX: 1, y: -1)
        tbl_chatShow.rowHeight = UITableView.automaticDimension
        tbl_chatShow.estimatedRowHeight = 44
    }
    
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

// MARK: - API Handling

extension ChatInterfaceView {
    
    func sendMessage(messageText: String) {
        if let conversationID = self.conversationID {
            sendContinueMessageToAPI(messageText: messageText, conversationID: conversationID)
        } else {
            sendMessageToAPI(messageText: messageText)
        }
    }
    
    func sendMessageToAPI(messageText: String) {
        let params: [String: Any] = [
            "user_id": "12345",
            "agent_id": agentID ?? "agent_01",
            "user_message": messageText
        ]
        
        // Add typing indicator message
        addTypingIndicator()
        
        APIManager.shared.MakePostAPICall(name: "start", params: params, viewController: self) { response, error, statusCode in
            
            // Remove typing indicator after response
            self.removeTypingIndicator()
            
            if let response = response, error == nil {
                print("Raw Response: \(response)")

                if let chatResponse = ChatResponseModel(JSON: response as! [String : Any]) {
                    self.conversationID = chatResponse.conversationId
                    self.respondToMessage(messageText: messageText, agentResponse: chatResponse.agentResponse)
                } else {
                    print("Failed to parse response")
                    self.respondToMessage(messageText: messageText, agentResponse: nil)
                }
            } else {
                print("Error: \(error ?? "Unknown error")")
                self.respondToMessage(messageText: messageText, agentResponse: nil)
            }
        }
    }
    
    func sendContinueMessageToAPI(messageText: String, conversationID: String) {
        let params: [String: Any] = [
            "user_id": "12345",
            "agent_id": agentID ?? "agent_01",
            "user_message": messageText,
            "conversation_id": conversationID
        ]
        
        // Add typing indicator message
        addTypingIndicator()
        
        APIManager.shared.MakePostAPICall(name: "continue", params: params, viewController: self) { response, error, statusCode in
            
            // Remove typing indicator after response
            self.removeTypingIndicator()
            
            if let response = response, error == nil {
                print("Raw Response: \(response)")

                if let chatResponse = ContinueChatModel(JSON: response as! [String : Any]) {
                    self.respondToMessage(messageText: messageText, agentResponse: chatResponse.agentResponse)
                    
                    // Handle the stages
                    if let currentStage = chatResponse.currentStage {
                        print("Current Stage: \(currentStage)")
                    }
                    
                    if let nextStage = chatResponse.nextStage {
                        print("Next Stage: \(nextStage)")
                    }
                    
                    if chatResponse.endOfConversation == true {
                        print("The conversation has ended.")
                    }

                } else {
                    print("Failed to parse response")
                    self.respondToMessage(messageText: messageText, agentResponse: nil)
                }
            } else {
                print("Error: \(error ?? "Unknown error")")
                self.respondToMessage(messageText: messageText, agentResponse: nil)
            }
        }
    }

    // MARK: - Typing Indicator Methods

    func addTypingIndicator() {
        // Add a "Typing..." message for the agent
        messages.insert(("Typing...", false), at: 0)
        tbl_chatShow.reloadData()
        scrollToTop()
    }

    func removeTypingIndicator() {
        // Remove the "Typing..." message
        if messages.first?.0 == "Typing..." {
            messages.removeFirst()
            tbl_chatShow.reloadData()
        }
    }
}




// MARK: - API Response Model using ObjectMapper

extension ChatInterfaceView {
    
    // Setup the step bar with progress restored from UserDefaults
    func setupStepBar() {
        // Load stored step progress from UserDefaults
        if let savedStepProgress = UserDefaults.standard.value(forKey: "stepProgress") as? Int {
            stepProgress = savedStepProgress
        }

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
    
    // Update step progress and save it to UserDefaults
    func updateStepProgress(step: Int) {
        stepProgress = step
        
        // Save the step progress to UserDefaults
        UserDefaults.standard.set(stepProgress, forKey: "stepProgress")
        
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
