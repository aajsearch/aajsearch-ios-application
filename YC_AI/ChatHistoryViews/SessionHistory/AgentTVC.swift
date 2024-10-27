import UIKit
import AVFoundation

class AgentTVC: UITableViewCell {
    
    @IBOutlet weak var lbl_agentMessage: UILabel!
    
    let speechSynthesizer = AVSpeechSynthesizer()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_agentMessage.font = appThemeFont(size: 16, fontname: .notoRegular)
        setupAgentMessageLabel()
    }

    @IBAction func clk_speak(_ sender: Any) {
        guard let text = lbl_agentMessage.text, !text.isEmpty else { return }
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechSynthesizer.speak(speechUtterance)
    }

    @IBAction func clk_copy(_ sender: Any) {
        guard let text = lbl_agentMessage.text, !text.isEmpty else { return }
        UIPasteboard.general.string = text
    }

    @IBAction func clk_like(_ sender: Any) {
    }

    @IBAction func clk_dislike(_ sender: Any) {
    }

    func setupAgentMessageLabel() {
        lbl_agentMessage.textColor = .black
        lbl_agentMessage.numberOfLines = 0
        lbl_agentMessage.lineBreakMode = .byWordWrapping
        lbl_agentMessage.backgroundColor = .clear
    }
}
