//
//  AlertViewController.swift
//  GTickets
//
//  Created by Rita Litvinenko on 4/7/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
  @IBOutlet weak var alertView: AlertView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    alertView.parent = self
  }
  
  func close() {
    guard let parent = parent as? AirticketSearchViewController else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    parent.removeAsChildViewController(self)
  }
  
}
