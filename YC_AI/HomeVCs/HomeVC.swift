import UIKit
import Alamofire
import ObjectMapper
import SDWebImage

class HomeVC: UIViewController {
    
    @IBOutlet weak var col_TopicList: UICollectionView!
    @IBOutlet weak var btn_profile: UIButton!
    
   
    var agents: [AgentModel] = [] // For storing API response
    
    let interval = 4
    let rowSpacing: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topicNib = UINib(nibName: "TopicCVC", bundle: nil)
        col_TopicList.register(topicNib, forCellWithReuseIdentifier: "TopicCVC")
        
        let topicWithLblNib = UINib(nibName: "TopicWithLblCVC", bundle: nil)
        col_TopicList.register(topicWithLblNib, forCellWithReuseIdentifier: "TopicWithLblCVC")
        
        col_TopicList.delegate = self
        col_TopicList.dataSource = self
        
       
        
        // Call the API to fetch agents data
        fetchAgentsData()
    }
    
    @IBAction func clk_profile(_ sender: Any) {
        let chatHistoryVC = UserProfileVC(nibName: "UserProfileVC", bundle: nil)
        self.navigationController?.pushViewController(chatHistoryVC, animated: true)
    }
    
    
    
    private func fetchAgentsData() {
        let url = "https://mvk1y0ssa3.execute-api.us-west-2.amazonaws.com/prod/agents"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("JSON Response: \(value)") // Print the full JSON response
                
                if let json = value as? [String: Any] {
                    print("Parsed JSON: \(json)") // Print the parsed JSON dictionary
                    
                    if let agentsData = json["agents"] as? [[String: Any]] {
                        print("Agents Data: \(agentsData)") // Print the agents data array
                        
                        self.agents = Mapper<AgentModel>().mapArray(JSONArray: agentsData)
                        self.col_TopicList.reloadData()
                    }
                }
            case .failure(let error):
                print("Error fetching agents: \(error)")
            }
        }
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return agents.count // Update to use agents count instead of topics
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let agent = agents[indexPath.row]
        
        if indexPath.row % (interval + 1) == interval {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicWithLblCVC", for: indexPath) as? TopicWithLblCVC else {
                return UICollectionViewCell()
            }
            cell.lbl_topicName.text = agent.Name
            cell.img_tpoic.sd_setImage(with: URL(string: agent.ImageURL ?? ""), placeholderImage: UIImage(named: "placeholder"))
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicCVC", for: indexPath) as? TopicCVC else {
                return UICollectionViewCell()
            }
            cell.lbl_topicName.text = agent.Name
            cell.img_tpoic.sd_setImage(with: URL(string: agent.ImageURL ?? ""), placeholderImage: UIImage(named: "placeholder"))
            return cell
        }
    }
    
    // Method to handle item selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedAgent = agents[indexPath.row]
           
           // Save selected agent to UserDefaults
           let selectedAgentData: [String: Any] = [
               "AgentID": selectedAgent.AgentID ?? "",
               "Name": selectedAgent.Name ?? "",
               "Specialization": selectedAgent.Specialization ?? ""
           ]
           
           // Retrieve existing data from UserDefaults
           var savedAgents = UserDefaults.standard.array(forKey: "SelectedAgents") as? [[String: Any]] ?? []
           
           // Append new selection
           savedAgents.append(selectedAgentData)
           
           // Save updated list back to UserDefaults
           UserDefaults.standard.set(savedAgents, forKey: "SelectedAgents")
           
           // Pass the selected agent's details to ChatInterfaceVC
           let chatInterfaceVC = ChatInterfaceView(nibName: "ChatInterfaceView", bundle: nil)
           chatInterfaceVC.agentID = selectedAgent.AgentID
           chatInterfaceVC.agentName = selectedAgent.Description
           chatInterfaceVC.agentImageURL = selectedAgent.ImageURL
           
           // Push the ChatInterfaceVC
           self.navigationController?.pushViewController(chatInterfaceVC, animated: true)
       }
    
}

// MARK: - AgentModel for ObjectMapper
class AgentModel: Mappable {
    var Specialization: String?
    var AgentID: String?
    var Description: String?
    var SystemPrompt: String?
    var ImageURL: String?
    var Name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        Specialization <- map["Specialization"]
        AgentID       <- map["AgentID"]
        Description   <- map["Description"]
        SystemPrompt  <- map["SystemPrompt"]
        ImageURL      <- map["ImageURL"]
        Name          <- map["Name"]
    }
}
