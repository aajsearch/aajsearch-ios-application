//  SessionInterfaceView.swift
//  YC_AI
//
//  Created by Geeta Manek on 24/10/24.
//

import UIKit

class SessionInterfaceView: UIViewController, UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource {

    @IBOutlet weak var tbl_Userchat: UITableView!
    @IBOutlet weak var txt_messageType: UITextField!
    @IBOutlet weak var vw_bottomCons: NSLayoutConstraint!
    @IBOutlet weak var stk_sendmessage: UIStackView!
    @IBOutlet weak var vw_stepbar: UIView!
    
    
    @IBOutlet weak var btn_close: UIButton!
    
    
    
    var agentID: String?
    var agentName: String?
    var agentImageURL: String?
    var conversationID: String?
    
    var messages: [(String, Bool)] = []
    var selectedTopics: [TopicModel] = []
    var chatHistory: [ChatModel] = []
    var stepProgress: Int = 0
    
    let phaseArray = ["Goal Understanding", "Classify", "Solve / Explain / Advise", "Adapt", "Interact / Engage", "Feedback", "Followup"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessagesFromStorage()
        
        setupStepBar()
        checkForStoredMessages()
        
        tbl_Userchat.delegate = self
        tbl_Userchat.dataSource = self
        
        // Register custom cells
        tbl_Userchat.register(UINib(nibName: "UserTVC", bundle: nil), forCellReuseIdentifier: "UserTVC")
        tbl_Userchat.register(UINib(nibName: "AgentTVC", bundle: nil), forCellReuseIdentifier: "AgentTVC")
        
        // Set text field delegate
        txt_messageType.delegate = self
        
        txt_messageType.layer.cornerRadius = 20
        txt_messageType.layer.masksToBounds = true
        txt_messageType.layer.borderColor = UIColor.clear.cgColor
        
        stk_sendmessage.layer.cornerRadius = 25
        stk_sendmessage.layer.masksToBounds = true
        
        btn_close.layer.cornerRadius  = 15
        btn_close.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Adjust view when keyboard shows
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            vw_bottomCons.constant = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            scrollToBottom()
        }
    }
    
    // Reset view when keyboard hides
    @objc func keyboardWillHide(notification: NSNotification) {
        vw_bottomCons.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func clk_close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    @IBAction func clk_messageSend(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.append((messageText, true))

            saveMessagesToStorage()
            tbl_Userchat.reloadData()
            scrollToBottom()
            sendMessage(messageText: messageText)
            txt_messageType.text = ""
//            lbl_agentDescription.isHidden = true
        }
    }

    func respondToMessage(messageText: String, agentResponse: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let response = agentResponse {
                self.self.messages.append((response, false))
            } else {
                self.messages.append(("I'm sorry, I don't understand.", false))

            }
            self.saveMessagesToStorage()
            self.tbl_Userchat.reloadData()
            self.scrollToBottom()
        }
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
            tbl_Userchat.reloadData()
        }
    }
    
    func checkForStoredMessages() {
        if !messages.isEmpty {
//            lbl_agentDescription.isHidden = true
        }
    }

    func scrollToBottom() {
        guard messages.count > 0 else { return } // Ensure that there is at least one message
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tbl_Userchat.scrollToRow(at: indexPath, at: .bottom, animated: true)

    }

    // MARK: - Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC", for: indexPath) as! UserTVC
            cell.lbl_userMessage.text = message.0
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTVC", for: indexPath) as! AgentTVC
            cell.lbl_agentMessage.text = message.0
            return cell
        }
    }
    
    // Remove observers when the view is deallocated
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



// MARK: - TableView DataSource & Delegate


// MARK: - API Handling
extension SessionInterfaceView {
    
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
extension SessionInterfaceView {
    
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
            
                let imageName = index < stepProgress ? "stepFill" : "step"
                stepImageView.image = UIImage(named: imageName)
                stepImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
                stepImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
           
            
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
                    imageView.image = UIImage(named: index < stepProgress ? "stepFill" : "step")
                }
            }
        }
    }
}

extension SessionInterfaceView {
    
    // MARK: - Typing Indicator Methods
    func addTypingIndicator() {
        messages.append(("Typing...", false))
        tbl_Userchat.reloadData()
        scrollToBottom()
    }
    
    func removeTypingIndicator() {
        if messages.last?.0 == "Typing..." {
            messages.removeLast()
            tbl_Userchat.reloadData()
        }
    }

}
