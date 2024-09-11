import UIKit

class ChatInterfaceView: UIViewController {

    @IBOutlet weak var tbl_chatShow: UITableView!
    @IBOutlet weak var txt_messageType: UITextField!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var lbl_agentDescription: UILabel!
    @IBOutlet weak var vw_messageType: UIView!
    @IBOutlet weak var btn_userProfile: UIButton!
    @IBOutlet weak var btn_more: UIButton! // Ensure this button is connected to the IBOutlet

    // Add properties for agent details
    var agentID: String?
    var agentName: String?
    var agentImageURL: String?

    var messages: [(String, Bool)] = []
    var selectedTopics: [TopicModel] = []
    var chatHistory: [ChatModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
       
        
        // Set agent description or other details
        lbl_agentDescription.text = "\(agentName ?? "Agent")"
        
        // Optionally set agent image or other data
    }

    // MARK: - Setup Methods
    
    func setupTableView() {
        tbl_chatShow.delegate = self
        tbl_chatShow.dataSource = self
        tbl_chatShow.register(UINib(nibName: "UserMessageTVC", bundle: nil), forCellReuseIdentifier: "UserMessageTVC")
        tbl_chatShow.register(UINib(nibName: "AgentMessageTVC", bundle: nil), forCellReuseIdentifier: "AgentMessageTVC")
        tbl_chatShow.separatorStyle = .none
    }
    
    
    
    // MARK: - Configuration Methods
    
    func configureChatData() {
        // Retrieve selected topics from UserDefaults
        if let savedTopics = UserDefaults.standard.array(forKey: "SelectedTopics") as? [[String: String]] {
            for topicData in savedTopics {
                let topic = TopicModel(id: topicData["id"]!, imageName: "", title: topicData["title"]!, description: topicData["description"]!)
                if !chatHistory.contains(where: { $0.id == Int(topic.id) }) {
                    chatHistory.append(ChatModel(id: Int(topic.id) ?? 0, agentTitle: topic.title))
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func clk_profile(_ sender: Any) {
        let userProfileVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    @IBAction func clk_send(_ sender: Any) {
        if let messageText = txt_messageType.text, !messageText.isEmpty {
            messages.append((messageText, true)) // Append user message
            tbl_chatShow.reloadData()
        //    scrollToBottom()
            txt_messageType.text = ""
        }
    }
    
    @IBAction func btn_more(_ sender: Any) {
        let chatHistoryVC = ChatHistoryVC(nibName: "ChatHistoryVC", bundle: nil)
        chatHistoryVC.chatData = chatHistory // Pass the chat data here
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    // MARK: - Keyboard Handling
    
   
    
    // MARK: - Deinit
    
   
}

// MARK: - TableView DataSource & Delegate
extension ChatInterfaceView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.1 { // User message
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageTVC", for: indexPath) as! UserMessageTVC
            cell.lbl_Message.text = message.0
            return cell
        } else { // Agent message
            let cell = tableView.dequeueReusableCell(withIdentifier: "AgentMessageTVC", for: indexPath) as! AgentMessageTVC
            cell.lbl_Message.text = message.0
            return cell
        }
    }
}
