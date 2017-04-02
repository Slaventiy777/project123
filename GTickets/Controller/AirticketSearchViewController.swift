//
//  AirticketSearchViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchViewController: UIViewController {
  
  @IBOutlet weak var viewContent: AirticketSearchView!
  
  fileprivate var fromSearchCity: AirticketSearchCityResultList!
  fileprivate var toSearchCity: AirticketSearchCityResultList!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewContent.delegate = self
    makeSearchCityControllers()
  }
  
  func makeSearchCityControllers() {
    fromSearchCity = storyboard?.instantiateViewController(withIdentifier: "AirticketSearchCityResultList") as! AirticketSearchCityResultList!
    fromSearchCity.view.frame = CGRect(x: 0, y: 0, width: viewContent.fromSearchResultContainer.frame.width, height: viewContent.fromSearchResultContainer.frame.height)
    viewContent.fromSearchResultContainer.addSubview(fromSearchCity.view)
    addChildViewController(fromSearchCity)
    fromSearchCity.delegate = self
    
    toSearchCity = storyboard?.instantiateViewController(withIdentifier: "AirticketSearchCityResultList") as! AirticketSearchCityResultList!
    toSearchCity.view.frame = CGRect(x: 0, y: 0, width: viewContent.toSearchResultContainer.frame.width, height: viewContent.toSearchResultContainer.frame.height)
    viewContent.toSearchResultContainer.addSubview(toSearchCity.view)
    addChildViewController(toSearchCity)
    toSearchCity.delegate = self
    
  }
  
}

extension AirticketSearchViewController: SearchCityViewDelegate {
  
  func fromTextFieldDidChange() {
    fromSearchCity.makeDataSource(city: viewContent.fromSearchCityText, callback: {
      viewContent.fromSearchResultContainerContentHeight = fromSearchCity.tableView.contentSize.height
    })
  }
  
  func toTextFieldDidChange() {
    toSearchCity.makeDataSource(city: viewContent.toSearchCityText, callback: {
      viewContent.toSearchResultContainerContentHeight = toSearchCity.tableView.contentSize.height
    })
  }

  func swapCityTextFieldsAction() {
    let fromSearchCityText = viewContent.fromSearchCityText
    let toSearchCityText = viewContent.toSearchCityText

    viewContent.fromSearchCityText = toSearchCityText
    viewContent.toSearchCityText = fromSearchCityText
    
    fromTextFieldDidChange()
    toTextFieldDidChange()
  }
  
  func cityChosed(text: String, from: UIViewController) {
    if from == fromSearchCity {
      viewContent.fromSearchCityText = text
    } else if from == toSearchCity {
      viewContent.toSearchCityText = text
    }
  }
  
}
