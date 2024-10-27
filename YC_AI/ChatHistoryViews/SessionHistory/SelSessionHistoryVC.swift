//
//  SelSessionHistoryVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 16/10/24.
//

import UIKit
import HMSegmentedControl

class SelSessionHistoryVC: UIViewController {
    
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_profile: UIImageView!
    @IBOutlet weak var segmentControl: HMSegmentedControl!
    @IBOutlet weak var dynamicContentView: UIView!
    var currentChildViewController: UIViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)

        
        btn_close.layer.cornerRadius = btn_close.frame.height / 2
        btn_close.layer.masksToBounds = true
        
        let segmentedControl = HMSegmentedControl(sectionTitles: [
                    "Insight",
                    "Chat"
                ])
        
                segmentedControl.frame = CGRect(x: 0, y: 0, width: segmentControl.bounds.width, height: segmentControl.bounds.height)
                segmentedControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
        segmentedControl.selectionIndicatorColor = UIColor.systemBlue
        
                segmentedControl.selectionIndicatorLocation = .bottom
                segmentedControl.selectionIndicatorHeight = 1
                segmentedControl.selectionStyle = .box
                segmentedControl.selectionIndicatorBoxColor = UIColor.clear
                segmentedControl.segmentWidthStyle = .fixed
                segmentedControl.selectedSegmentIndex = 0
        
                let txtAttr: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.black
                ]
        
                let selectedTXTAttr: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.foregroundColor: UIColor.systemBlue
                    
                ]
        
                segmentedControl.selectedTitleTextAttributes = selectedTXTAttr
                segmentedControl.titleTextAttributes = txtAttr
        
                let lineView = UIView(frame: CGRect(x: 0, y: segmentControl.frame.height - 2, width: segmentControl.frame.width, height:  1))
        lineView.backgroundColor = UIColor(hexString: "EBEBEB", alpha: 1)
                lineView.layer.zPosition = -1
                segmentedControl.addSubview(lineView)
        
                segmentControl.addSubview(segmentedControl)
                segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
                NSLayoutConstraint.activate([
                    segmentedControl.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor, constant: 0),
                    segmentedControl.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor, constant: 0),
                    segmentedControl.topAnchor.constraint(equalTo: segmentControl.topAnchor, constant: 0),
                    segmentedControl.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 0)
                ])
        
                segmentedControl.addSubview(lineView)
                lineView.translatesAutoresizingMaskIntoConstraints = false
        
                NSLayoutConstraint.activate([
                    lineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor),
                    lineView.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor),
                    lineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
                    lineView.heightAnchor.constraint(equalToConstant: 1)
                ])
        switchToViewController(identifier: "Insight")
        
        segmentControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
      
        
//        bgView.layer.cornerRadius = 24
//        bgView.clipsToBounds = true
        
       

        
        
    }
    
    @objc func segmentedControlChangedValue(segmentedControl: HMSegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            switchToViewController(identifier: "Insight")
        } else {
            switchToViewController(identifier: "Chat")
        }
    }
    
    func setupSegmentedControl() {
        segmentControl.sectionTitles = ["Insight", "Chat"]
        segmentControl.selectionIndicatorColor = .red
        segmentControl.selectionIndicatorLocation = .bottom
        segmentControl.selectionIndicatorHeight = 1
        segmentControl.selectionStyle = .box
        segmentControl.selectionIndicatorBoxColor = .clear
        segmentControl.segmentWidthStyle = .fixed
        
        let txtAttr: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black ,
            .font: UIFont(name: "Montserrat-Regular", size: 11)!
        ]
        
        let selectedTXTAttr: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont(name: "Montserrat-Regular", size: 11)!
        ]
        
        segmentControl.selectedTitleTextAttributes = selectedTXTAttr
        segmentControl.titleTextAttributes = txtAttr
        
        let lineView = UIView()
        lineView.backgroundColor = (UIColor(hexString: "EBEBEB", alpha: 1))
        lineView.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: segmentControl.trailingAnchor),
            lineView.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        segmentControl.addTarget(self, action: #selector(segmentedControlChangedValue(segmentedControl:)), for: .valueChanged)
      
    }
    
    func switchToViewController(identifier: String) {
        if let currentVC = currentChildViewController {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
       
        
        var newVC: UIViewController
        if identifier == "Insight" {
            newVC = SessionInterfaceVC(nibName: "SessionInterfaceVC", bundle: nil)
            newVC.view.layoutIfNeeded()
            print(newVC.view.frame.size.height)
            view.layoutIfNeeded()
         
        } else {
            newVC = SessionchatView(nibName: "SessionchatView", bundle: nil)
            newVC.view.layoutIfNeeded()
            print(newVC.view.frame.size.height)
            view.layoutIfNeeded()
           
        }
        
        addChild(newVC)
        
        newVC.view.frame = dynamicContentView.bounds
        dynamicContentView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        
        currentChildViewController = newVC
        
       
    }
    
    @IBAction func clk_close(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
   
    
}
