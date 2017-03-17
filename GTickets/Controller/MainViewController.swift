//
//  MainViewController.swift
//  GTickets
//
//  Created by Slava on 3/15/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit
import LGSideMenuController

class MainViewController: LGSideMenuController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let navigationViewController = self.storyboard?.instantiateViewController(withIdentifier: "navigationViewController")
    self.rootViewController = navigationViewController
    
    let leftViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftMenuViewController") as! LeftMenuViewController
    
    self.leftViewController = leftViewController
    self.leftViewWidth = 250.0
    self.leftViewPresentationStyle = .slideAbove
  }
    
}
