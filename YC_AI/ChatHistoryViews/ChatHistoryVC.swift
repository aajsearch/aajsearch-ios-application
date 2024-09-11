import UIKit

class ChatHistoryVC: UIViewController {
    
    @IBOutlet weak var tbl_chatHistory: UITableView!
    
    var chatData: [ChatModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve chat data from UserDefaults
        if let savedAgents = UserDefaults.standard.array(forKey: "SelectedAgents") as? [[String: Any]] {
            chatData = savedAgents.compactMap {
                guard let id = $0["AgentID"] as? String, let title = $0["Name"] as? String else {
                    return nil
                }
                return ChatModel(id: Int(id) ?? 0, agentTitle: title)
            }
        }
        
        tbl_chatHistory.delegate = self
        tbl_chatHistory.dataSource = self
        tbl_chatHistory.register(UINib(nibName: "ChatHistoryTVC", bundle: nil), forCellReuseIdentifier: "ChatHistoryTVC")
    }
}

// MARK: - TableView DataSource & Delegate

extension ChatHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatHistoryTVC", for: indexPath) as? ChatHistoryTVC else {
            return UITableViewCell()
        }
        let chat = chatData[indexPath.row]
        cell.lbl_AgentTitle.text = chat.agentTitle
        return cell
    }
}

