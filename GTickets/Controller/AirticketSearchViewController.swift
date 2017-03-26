//
//  AirticketSearchViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchViewController: UIViewController {
  
  @IBOutlet weak var viewContent: AirticketSearchViewContent!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewContent.update()
    
  }
  
}
