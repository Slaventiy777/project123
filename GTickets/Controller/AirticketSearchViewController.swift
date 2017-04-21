//
//  AirticketSearchViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

protocol AirticketSearchDateDelegate: class {
  func setDates(type: TypeDate, from: Date?, to: Date?)
}

class AirticketSearchViewController: UIViewController {

  @IBOutlet weak var viewContent: AirticketSearchView!

  fileprivate var fromSearchCity: AirticketSearchCityResultList!
  fileprivate var toSearchCity: AirticketSearchCityResultList!

  fileprivate var dispatchDateController: RangeOfDatesCalendarController?
  fileprivate var arrivalDateController: RangeOfDatesCalendarController?

  fileprivate var visaCheckoutDateController: OneDateCalendarController?

  fileprivate var currentTypePicker: TypePicker?

  fileprivate lazy var picker: UIPickerView = { [weak self] in
    guard let strongSelf = self else {
      return UIPickerView()
    }
    
    let mainWindow = UIScreen.main.bounds
    let heightPicker: CGFloat = mainWindow.height / 5
    let heightNavBar = strongSelf.navigationController?.navigationBar.frame.size.height ?? 0
    
    let picker = UIPickerView(frame: CGRect(x: 0,
                                            y: mainWindow.height - heightPicker - heightNavBar,
                                            width: mainWindow.width,
                                            height: heightPicker))
    picker.backgroundColor = UIColor.white
    
    picker.dataSource = strongSelf
    picker.delegate = strongSelf
    
    strongSelf.view.addSubview(picker)
    picker.isHidden = true
    
    return picker
  }()

  fileprivate let dataSearch = AirticketSearchData()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewContent.delegate = self    
    viewContent.updateInfo(dataSearch)
    
    makeSearchCityControllers()
  }

  private func makeSearchCityControllers() {
    makeSearchCityController(searchCity: &fromSearchCity, viewContainer: viewContent.fromSearchResultContainer)
    makeSearchCityController(searchCity: &toSearchCity, viewContainer: viewContent.toSearchResultContainer)
  }

  private func makeSearchCityController(searchCity: inout AirticketSearchCityResultList!, viewContainer: UIView) {
    let searchCityController = storyboard?.instantiateViewController(withIdentifier: "AirticketSearchCityResultList")
    
    if let searchCityController = searchCityController as? AirticketSearchCityResultList {
      searchCity = searchCityController
      searchCity.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: viewContainer.frame.width,
                                     height: viewContainer.frame.height)
      viewContainer.addSubview(searchCity.view)
      addChildViewController(searchCity)
      
      searchCity.delegate = self
    }
  }

}

extension AirticketSearchViewController: SearchCityViewDelegate {

  func fromTextFieldDidChange(_ text: String) {
    dataSearch.fromCity = text
    
    fromSearchCity.makeDataSource(city: text) {
      viewContent.fromSearchResultContainerContentHeight = fromSearchCity.tableView.contentSize.height
    }
  }

  func toTextFieldDidChange(_ text: String) {
    dataSearch.toCity = text
    
    toSearchCity.makeDataSource(city: text) {
      viewContent.toSearchResultContainerContentHeight = toSearchCity.tableView.contentSize.height
    }
  }

  func swapCityTextFieldsAction() {
    let fromSearchCity = dataSearch.fromCity ?? ""
    let toSearchCity = dataSearch.toCity ?? ""
    
    viewContent.fromTextField.text = toSearchCity
    viewContent.toTextField.text = fromSearchCity
    
    fromTextFieldDidChange(toSearchCity)
    toTextFieldDidChange(fromSearchCity)
  }

  func cityChosed(text: String, from: UIViewController) {
    if from == fromSearchCity {
      viewContent.fromTextField.text = text
      fromTextFieldDidChange(text)
    } else if from == toSearchCity {
      viewContent.toTextField.text = text
      toTextFieldDidChange(text)
    }
    
    viewContent.dismissKeyboard()
  }

  func chooseArrivalDate() {
    chooseRangeDates(type: .return, dateController: &dispatchDateController)
  }

  func chooseDispatchDate() {
    chooseRangeDates(type: .departure, dateController: &arrivalDateController)
  }

  func chooseDateVisaCheckout() {
    chooseDate(type: .visa, dateController: &visaCheckoutDateController)
  }

  private func chooseDate(type: TypeDate, dateController: inout OneDateCalendarController?) {
    if dateController == nil {
      let storyboard = UIStoryboard(name: "Calendar", bundle: nil)
      let calendarView = storyboard.instantiateViewController(withIdentifier: "CalendarController").view
      
      guard let calendarViewGT = calendarView as? GTCalendarView else {
        return
      }
      
      dateController = OneDateCalendarController(type: type)
      dateController?.delegate = self
      dateController?.calendarView = calendarViewGT
    }
    
    let navController = UINavigationController(rootViewController: dateController!)
    present(navController, animated: true, completion: nil)
  }

  private func chooseRangeDates(type: TypeDate, dateController: inout RangeOfDatesCalendarController?) {
    if dateController == nil {
      let storyboard = UIStoryboard.init(name: "Calendar", bundle: nil)
      let calendarView = storyboard.instantiateViewController(withIdentifier: "CalendarController").view
      
      guard let calendarViewGT = calendarView as? GTCalendarView else {
        return
      }
      
      dateController = RangeOfDatesCalendarController(type: type)
      dateController?.delegate = self
      dateController?.calendarView = calendarViewGT
    }
    
    let navController = UINavigationController(rootViewController: dateController!)
    present(navController, animated: true, completion: nil)
  }

  func chooseBaggage(_ baggage: Baggage) {
    dataSearch.baggage = baggage
  }
  
  func chooseDirectFlight(_ isSelect: Bool) {
    dataSearch.isDirectFlight = isSelect
  }
  
  func chooseVisaCheckout(_ isSelect: Bool) {
    dataSearch.isVisaCheckout = isSelect
  }

  func search() {
    RequestManager.post(urlPath: "/api/order", params: dataSearch.dictionary()) { [weak self] json in
      guard let strongSelf = self else {
        return
      }
      
      //TODO: do something (for example auth)
      
      guard let alertViewController = AlertViewController.storyboardInstance() else {
        return
      }
      
      if let alertView = alertViewController.view as? AlertView {
        alertView.alertType = AlertType.donePurple
      }
      
      strongSelf.present(alertViewController, animated: true, completion: nil)
    }
  }

}

extension AirticketSearchViewController: AirticketSearchDateDelegate {

  func setDates(type: TypeDate, from: Date?, to: Date?) {
    switch type {
    case .departure:
      dataSearch.fromDepartureDate = from
      dataSearch.toDepartureDate = to
    case .return:
      dataSearch.fromReturnDate = from
      dataSearch.toReturnDate = to
    case .visa:
      dataSearch.dateVisaCheckout = from
    }
    
    viewContent.setTitleDates(type: type, from: from, to: to)
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
      dataSearch.numberOfPassengers = Passenger.array[row]
      
      viewContent.countPeopleLabel.text = "\(dataSearch.numberOfPassengers.rawValue)"
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
