//
//  AirticketSearchViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit
import MKDropdownMenu

class AirticketSearchViewController: UIViewController {
  
  @IBOutlet weak var viewContent: AirticketSearchView!
  
  let airticketSearchData = AirticketSearchData()
  
  fileprivate var fromSearchCity: AirticketSearchCityResultList!
  fileprivate var toSearchCity: AirticketSearchCityResultList!
  
  fileprivate var dispatchDateController: RangeOfDatesCalendarController?
  fileprivate var arrivalDateController: RangeOfDatesCalendarController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewContent.delegate = self
    viewContent.updateInfo(airticketSearchData)
    
    let dropdownMenu = MKDropdownMenu(frame: CGRect(x: 0, y: 0, width: 80, height: 100))
    dropdownMenu.dataSource = self
    dropdownMenu.delegate = self
    viewContent.countPeopleView.addSubview(dropdownMenu)
    
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
  
  func chooseArrivalDate() {
    if dispatchDateController == nil {
      let calendarView: GTCalendarView = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarController").view as! GTCalendarView
      dispatchDateController = RangeOfDatesCalendarController()
      dispatchDateController?.calendarView = calendarView
      //    self.navigationController?.pushViewController(controller, animated: true)
    }
    let navController = UINavigationController(rootViewController: dispatchDateController!)
    present(navController, animated:true, completion: nil)
  }
  
  func chooseDispatchDate() {
    if arrivalDateController == nil {
      let calendarView: GTCalendarView = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarController").view as! GTCalendarView
      arrivalDateController = RangeOfDatesCalendarController()
      arrivalDateController?.calendarView = calendarView
      //self.navigationController?.pushViewController(controller, animated: true)
    }
    let navController = UINavigationController(rootViewController: arrivalDateController!)
    present(navController, animated:true, completion: nil)
  }
  
  func search() {
    let params = [
      /*
      //"id": UIDevice.current.identifierForVendor!.uuidString,
      "from":"from",
      "to":"to",
      "from_date_there":"2017-04-21 22:45:53",
      "from_date_back":"2017-04-21 22:45:53",
      "class":2,
      "count_passenger":5,
      "baggage":1,
      "direct_flight":1,
      "visa_date":"2017-04-21 22:45:53",
      "visa_days":5,
      "to_date_there":"2017-04-21 22:45:53",
      "to_date_back":"2017-04-21 22:45:53",
      "comment":"comment"
      */
      :] as Dictionary<String, Any>
    
    RequestManager.post(urlPath: "/api/order", params: params) { data in
      
    }
  }
  
}

extension AirticketSearchViewController: MKDropdownMenuDataSource {
  
  func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
    return 1
  }
  
  func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
    return People.count
  }
  
}

extension AirticketSearchViewController: MKDropdownMenuDelegate {
  
  func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(row)
  }
  
}

