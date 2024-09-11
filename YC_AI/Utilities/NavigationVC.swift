//
//  NavigationVC.swift
//  YC_AI
//
//  Created by Geeta Manek on 24/08/24.
//

import Foundation
import UIKit

class NavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    /// Custom back buttons disable the interactive pop animation
    /// To enable it back we set the recognizer to `self`
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
}
