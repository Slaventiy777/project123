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
  
  private var fromSearchCity: SearchCityViewController!
  private var toSearchCity: SearchCityViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewContent.update()
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "FromSearchCityIdentifier" {
      fromSearchCity = segue.destination as? SearchCityViewController
    } else if segue.identifier == "ToSearchCityIdentifier" {
      toSearchCity = segue.destination as? SearchCityViewController
    }
  }
  
}
