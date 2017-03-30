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
    
    let navigationViewController =  MasterNavigationController.storyboardInstance()
    self.rootViewController = navigationViewController
    
    let leftViewController = LeftMenuViewController.storyboardInstance()
    
    self.leftViewController = leftViewController
    self.leftViewPresentationStyle = .slideAbove
  }
    
}
