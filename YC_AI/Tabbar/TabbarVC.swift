//
//  TabbarVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 13/10/24.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = UINavigationController(rootViewController: HomeVC(nibName: "HomeVC", bundle: nil))
        let secondVC = UINavigationController(rootViewController: SessionInterfaceView(nibName: "SessionInterfaceView", bundle: nil))
        let thirdVC = UINavigationController(rootViewController: UserProfileVC(nibName: "UserProfileVC", bundle: nil))
      

        // Assign tab bar items with specified images for both selected and unselected states
        firstVC.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(named: "search12"), selectedImage: UIImage(named: "search12"))
        secondVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(named: "message-outline"), selectedImage: UIImage(named: "Smessage-outline"))
        thirdVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "profile-outline"), selectedImage: UIImage(named: "Sprofile-outline"))
       

        // Add the view controllers to the tab bar
        viewControllers = [firstVC, secondVC, thirdVC]
        tabBar.barTintColor = .white
               tabBar.isTranslucent = false
        
    }

    
}

