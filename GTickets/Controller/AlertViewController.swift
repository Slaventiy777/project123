//
//  AlertViewController.swift
//  GTickets
//
//  Created by Rita Litvinenko on 4/7/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
//  @IBOutlet weak var alertView: AlertView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    (view as! AlertView).parent = self
  }
  
  func close() {
    dismiss(animated: true, completion: nil)
  }
  
}
