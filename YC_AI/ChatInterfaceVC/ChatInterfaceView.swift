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
    @IBOutlet weak var cons_btn_bottom: NSLayoutConstraint!
    
    
    @IBOutlet weak var stk_msgType: UIStackView!
    @IBOutlet weak var vw_static: UIView!
    
    var agentID: String?
    var agentName: String?
    var agentImageURL: String?
    var conversationID: String?
    
    var messages: [(String, Bool)] = []
    var selectedTopics: [TopicModel] = []
    var chatHistory: [ChatModel] = []
    var stepProgress: Int = 0
    
    let phaseArray = ["Goal Understanding", "Classify", "Solve / Explain / Advise", "Adapt", "Interact / Engage", "Feedback", "Followup"]
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadMessagesFromStorage()
        lbl_agentDescription.text = "\(agentName ?? "Agent")"
        
        setupStepBar()
        checkForStoredMessages()
        
        btn_userProfile.layer.cornerRadius = 20
        btn_userProfile.layer.masksToBounds = true
        
        stk_msgType.layer.cornerRadius = 20
        stk_msgType.layer.masksToBounds = true
        txt_messageType.layer.cornerRadius = 20
        txt_messageType.layer.masksToBounds = true
        txt_messageType.layer.borderColor = UIColor.clear.cgColor
        
        cons_btn_bottom.constant = 16
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tbl_chatShow.addGestureRecognizer(tapGesture)
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if cons_btn_bottom.constant == 16 {
                cons_btn_bottom.constant =  keyboardSize.height
                lbl_agentDescription.isHidden = true
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if cons_btn_bottom.constant != 16{
            cons_btn_bottom.constant = 16
            checkForStoredMessages()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func hideKeyboard() {
        view.endEditing(true)  // Hides the keyboard
    }
    
    // MARK: - Button Actions
    @IBAction func clk_send(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.insert((messageText, true), at: 0)
            saveMessagesToStorage()
            tbl_chatShow.reloadData()
            scrollToTop()
            sendMessage(messageText: messageText)
            txt_messageType.text = ""
            lbl_agentDescription.isHidden = true
        }
    }
    
    @IBAction func  clk_more(_ sender: Any){
        let chatInterfaceVC = ChatHistoryVC(nibName: "ChatHistoryVC", bundle: nil)
        self.navigationController?.pushViewController(chatInterfaceVC, animated: true)
    }
    
    @IBAction func  clk_profile(_ sender: Any){
        let chatInterfaceVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(chatInterfaceVC, animated: true)
    }
    
    @IBAction func  clk_back(_ sender: Any){
        navigationController?.popViewController(animated: true)
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
        }
    }
    
    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        tbl_chatShow.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    // MARK: - Message Persistence
    func saveMessagesToStorage() {
        guard let agentID = agentID else { return }
        
        let savedMessages = messages.map { [$0.0, $0.1 ? "user" : "agent"] }
        
        // Retrieve existing messages for all agents
        var chatStorage = UserDefaults.standard.dictionary(forKey: "agentChats") as? [String: [[String]]] ?? [:]
        
        // Update the chat for the current agent
        chatStorage[agentID] = savedMessages
        
        // Save the updated chatStorage back to UserDefaults
        UserDefaults.standard.set(chatStorage, forKey: "agentChats")
    }
    
    func loadMessagesFromStorage() {
        guard let agentID = agentID else { return }
        
        // Retrieve messages for all agents
        let chatStorage = UserDefaults.standard.dictionary(forKey: "agentChats") as? [String: [[String]]] ?? [:]
        
        // Load messages specific to this agent
        if let savedMessages = chatStorage[agentID] {
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
            print(cell.lbl_Message.text)
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentMessageTVC", for: indexPath) as! AgentMessageTVC
            cell.lbl_Message.text = message.0
            print(cell.lbl_Message.text)
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
        
        addTypingIndicator()
        
        APIManager.shared.MakePostAPICall(name: "start", params: params, viewController: self) { response, error, statusCode in
            
            self.removeTypingIndicator()
            
            if let response = response, error == nil {
                print("Raw Response: \(response)")
                
                if let chatResponse = ChatResponseModel(JSON: response as! [String : Any]) {
                    self.conversationID = chatResponse.conversationId
                    
                    if let systemCommunication = chatResponse.systemCommunication,
                       let phase = systemCommunication.phase {
                        
                        let phasesArray = ["Goal Understanding", "Classify", "Solve / Explain / Advise", "Adapt", "Interact / Engage", "Feedback", "Followup"]
                        
                        if let phaseIndex = phasesArray.firstIndex(of: phase) {
                            self.updateStepProgress(step: phaseIndex + 1)
                        }
                    }
                    
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
        
        addTypingIndicator()
        
        APIManager.shared.MakePostAPICall(name: "continue", params: params, viewController: self) { response, error, statusCode in
            
            self.removeTypingIndicator()
            
            if let response = response, error == nil {
                print("Raw Response: \(response)")
                
                if let continueChatResponse = ContinueChatModel(JSON: response as! [String : Any]) {
                    self.conversationID = continueChatResponse.conversationId
                    
                    if let systemCommunication = continueChatResponse.systemCommunication,
                       let phase = systemCommunication.phase {
                        
                        let phasesArray = ["Goal Understanding", "Classify", "Solve / Explain / Advise", "Adapt", "Interact / Engage", "Feedback", "Followup"]
                        
                        if let phaseIndex = phasesArray.firstIndex(of: phase) {
                            self.updateStepProgress(step: phaseIndex + 1)
                        }
                    }
                    self.respondToMessage(messageText: messageText, agentResponse: continueChatResponse.agentResponse)
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
    
    
}

// MARK: - Step Bar Setup and Update
extension ChatInterfaceView {
    
    func setupStepBar() {
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
    
    func updateStepProgress(step: Int) {
        stepProgress = step
        
        UserDefaults.standard.set(stepProgress, forKey: "stepProgress")
        
        if let stackView = vw_stepbar.subviews.first as? UIStackView {
            for (index, view) in stackView.arrangedSubviews.enumerated() {
                if let imageView = view as? UIImageView {
                    if index % 2 == 0 {
                        imageView.image = UIImage(named: index < stepProgress ? "circle_fill" : "circle")
                    } else {
                        imageView.image = UIImage(named: index < stepProgress ? "rectangle_fill" : "rectangle")
                    }
                }
            }
        }
    }
}

extension ChatInterfaceView {
    
    // MARK: - Typing Indicator Methods
    func addTypingIndicator() {
        messages.insert(("Typing...", false), at: 0)
        tbl_chatShow.reloadData()
        scrollToTop()
    }
    
    func removeTypingIndicator() {
        if messages.first?.0 == "Typing..." {
            messages.removeFirst()
            tbl_chatShow.reloadData()
        }
    }
}
