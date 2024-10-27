import UIKit

class SessionchatView: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tbl_Userchat: UITableView!
    @IBOutlet weak var txt_messageType: UITextField!
    @IBOutlet weak var vw_bottomCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var stk_sendmessage: UIStackView!
    
    var messages: [String] = [] // Stores chat messages
    var isUserMessage: [Bool] = [] // Stores whether the message is from the user or agent
    
    // Mock responses for different topics
    let mockResponses: [String: [String]] = [
        "how to save money": [
            "Start by creating a budget and sticking to it.Consider setting up a savings account with automatic transfers.Track your spending and look for areas to cut back."
          
        ],
        // Add other mock data here...
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        
        // Set up table view
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Load previously saved messages
        loadMessages()
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
            scrollToBottom() // Ensure the latest message is visible
        }
    }
    
    // Reset view when keyboard hides
    @objc func keyboardWillHide(notification: NSNotification) {
        vw_bottomCons.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func clk_messageSend(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            // Add user message
            messages.append(messageText)
            isUserMessage.append(true)
            
            // Clear the text field and reload the table view
            txt_messageType.text = ""
            tbl_Userchat.reloadData()
            
            // Scroll to the latest message
            scrollToBottom()
            
            // Save the chat history
            saveMessages()
            
            // Simulate agent response after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.respondToUserMessage(messageText)
            }
        }
    }

    func respondToUserMessage(_ userMessage: String) {
        // Search for a related response in the mock data
        if let responses = mockResponses[userMessage.lowercased()], !responses.isEmpty {
            for response in responses {
                messages.append(response)
                isUserMessage.append(false)
            }
        } else {
            // Default agent response if no match found
            messages.append("I'm sorry, I don't have an answer for that right now.")
            isUserMessage.append(false)
        }
        
        tbl_Userchat.reloadData()
        scrollToBottom()
        
        // Save the chat history
        saveMessages()
    }

    
    

    func scrollToBottom() {
        guard messages.count > 0 else { return } // Ensure that there is at least one message
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tbl_Userchat.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func saveMessages() {
        UserDefaults.standard.set(messages, forKey: "messages")
        UserDefaults.standard.set(isUserMessage, forKey: "isUserMessage")
    }

    func loadMessages() {
        if let savedMessages = UserDefaults.standard.array(forKey: "messages") as? [String],
           let savedIsUserMessage = UserDefaults.standard.array(forKey: "isUserMessage") as? [Bool] {
            messages = savedMessages
            isUserMessage = savedIsUserMessage
            tbl_Userchat.reloadData()
            scrollToBottom() // Ensure that the latest message is visible
        }
    }


    // MARK: - Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUserMessage[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVC", for: indexPath) as! UserTVC
            // Configure user message cell
            cell.lbl_userMessage.text = messages[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentTVC", for: indexPath) as! AgentTVC
            // Configure agent message cell
            cell.lbl_agentMessage.text = messages[indexPath.row]
            return cell
        }
    }
    
    // Remove observers when the view is deallocated
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
