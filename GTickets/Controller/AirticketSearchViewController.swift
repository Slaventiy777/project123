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
  
  fileprivate var fromSearchCity: AirticketSearchCityResultList!
  fileprivate var toSearchCity: AirticketSearchCityResultList!
  
  fileprivate var dispatchDateController: RangeOfDatesCalendarController?
  fileprivate var arrivalDateController: RangeOfDatesCalendarController?

  fileprivate var visaCheckoutDateController: OneDateCalendarController?

  fileprivate var currentTypePicker: TypePicker?
  
  fileprivate var picker: UIPickerView!
  
  fileprivate var dataSearch: AirticketSearchData!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSearch = AirticketSearchData()
      
    viewContent.delegate = self
    
    viewContent.updateInfo(dataSearch)
    
    
//    let dropdownMenu = MKDropdownMenu(frame: CGRect(x: 0, y: 0, width: 80, height: 100))
//    dropdownMenu.dataSource = self
//    dropdownMenu.delegate = self
//    viewContent.countPeopleView.addSubview(dropdownMenu)
    
    picker = UIPickerView(frame: CGRect(x: 0,
                                        y: UIScreen.main.bounds.height - 100 - 64,
                                        width: UIScreen.main.bounds.width,
                                        height: 100))
    picker.backgroundColor = UIColor.white
    
    picker.dataSource = self
    picker.delegate = self
    
    view.addSubview(picker)
    picker.isHidden = true
    
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
  
  func chooseDateVisaCheckout() {
    if visaCheckoutDateController == nil {
      let calendarView: GTCalendarView = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarController").view as! GTCalendarView
      visaCheckoutDateController = OneDateCalendarController()
      visaCheckoutDateController?.calendarView = calendarView
      //self.navigationController?.pushViewController(controller, animated: true)
    }
    let navController = UINavigationController(rootViewController: visaCheckoutDateController!)
    present(navController, animated:true, completion: nil)
  }
  
  func search() {
    RequestManager.post(urlPath: "/api/order", params: dataSearch.dictionary()) { json in
      //TODO: do something (for example auth)
    }
  }
  
}

extension AirticketSearchViewController: AirticketSearchPickerDelegate {
  
  func showPicker(type: TypePicker) {
  
    currentTypePicker = type
    
    picker.alpha = 0
    picker.isHidden = false
    picker.reloadAllComponents()
    
    UIView.animate(withDuration: 0.3) {
      self.picker.alpha = 1
    }
  }
  
}

extension AirticketSearchViewController: MKDropdownMenuDataSource {
  
  func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
    return 1
  }
  
  func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
    return Passenger.count
  }
  
}

extension AirticketSearchViewController: MKDropdownMenuDelegate {
  
  func dropdownMenu(_ dropdownMenu: MKDropdownMenu, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(row)
  }
  
}

extension AirticketSearchViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let currentTypePicker = currentTypePicker else {
      return 0
    }
    
    var numberOfRows = 0
    if currentTypePicker == .passenger {
      numberOfRows = Passenger.count
    } else if currentTypePicker == .baggage {
      numberOfRows = ComfortClass.count
    } else if currentTypePicker == .visaDays {
      numberOfRows = VisaDays.count
    }
    
    return numberOfRows
  }
  
}

extension AirticketSearchViewController: UIPickerViewDelegate {
 
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let currentTypePicker = currentTypePicker else {
      return nil
    }
    
    var titleForRow = ""
    if currentTypePicker == .passenger {
      titleForRow = "\(Passenger.array[row].rawValue)"
    } else if currentTypePicker == .baggage {
      titleForRow = ComfortClass.array[row].name
    } else if currentTypePicker == .visaDays {
      titleForRow = "\(VisaDays.array[row].rawValue)"
    }
    
    return titleForRow
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   
    if currentTypePicker == .passenger {
      dataSearch.countPassenger = Passenger.array[row]
      
      viewContent.countPeopleLabel.text = "\(dataSearch.countPassenger.rawValue)"
    } else if currentTypePicker == .baggage {
      dataSearch.comfortClass = ComfortClass.array[row]
      
      viewContent.comfortClassLabel.text = dataSearch.comfortClass.name
    } else if currentTypePicker == .visaDays {
      dataSearch.visaDays = VisaDays.array[row]
      
      viewContent.daysOfStayLabel.text = "\(dataSearch.visaDays.rawValue)"
    }
    
    UIView.animate(withDuration: 0.3, animations: {
      self.picker.alpha = 0
    }, completion: { (ok) in
      self.picker.isHidden = true
    })
    
  }
  
}

