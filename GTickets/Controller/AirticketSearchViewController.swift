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
  func enableGestureRecognizers(isEnable: Bool)
}

class AirticketSearchViewController: UIViewController {
  fileprivate let CITY_CONTAINER_MAX_HEIGHT = 300 as CGFloat
  
  @IBOutlet weak var viewContent: AirticketSearchView!

  fileprivate var fromSearchCity: AirticketSearchCityResultList!
  fileprivate var toSearchCity: AirticketSearchCityResultList!

  fileprivate var dispatchDateController: RangeOfDatesCalendarController?
  fileprivate var arrivalDateController: RangeOfDatesCalendarController?

  fileprivate var visaCheckoutDateController: OneDateCalendarController?

  fileprivate var currentTypePicker: TypePicker?

  fileprivate lazy var pickerTitle: UILabel = { [weak self] in
    guard let strongSelf = self else {
      return UILabel()
    }
    
    let mainWindow = UIScreen.main.bounds
    let heightTitle: CGFloat = 30
    let heightNavBar = strongSelf.navigationController?.navigationBar.frame.size.height ?? 0
    
    let pickerTitle = UILabel(frame: CGRect(x: 0,
                                            y: strongSelf.picker.frame.minY - heightTitle,
                                            width: mainWindow.width,
                                            height: heightTitle))
    pickerTitle.textAlignment = .center
    pickerTitle.backgroundColor = UIColor.white
    
    return pickerTitle
  }()
  
  fileprivate lazy var picker: UIPickerView = { [weak self] in
    guard let strongSelf = self else {
      return UIPickerView()
    }
    
    let mainWindow = UIScreen.main.bounds
    let heightPicker: CGFloat = mainWindow.height / 6
    let heightNavBar = strongSelf.navigationController?.navigationBar.frame.size.height ?? 0
    
    let picker = UIPickerView(frame: CGRect(x: 0,
                                            y: mainWindow.height - heightPicker - heightNavBar,
                                            width: mainWindow.width,
                                            height: heightPicker))
    picker.backgroundColor = UIColor.white
    
    picker.dataSource = strongSelf
    picker.delegate = strongSelf
    
    //strongSelf.view.addSubview(picker)
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
      viewContent.fromSearchResultContainerContentHeight = min(fromSearchCity.tableView.contentSize.height, CITY_CONTAINER_MAX_HEIGHT)
    }
  }

  func toTextFieldDidChange(_ text: String) {
    dataSearch.toCity = text
    
    toSearchCity.makeDataSource(city: text) {
      viewContent.toSearchResultContainerContentHeight = min(toSearchCity.tableView.contentSize.height, CITY_CONTAINER_MAX_HEIGHT)
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
    
    if let dateController = dateController {
      enableGestureRecognizers(isEnable: false)
      addAsChildViewController(dateController)
      //present(dateController, animated: true, completion: nil)
    }
    
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
      
      if dateController == dispatchDateController {
        dispatchDateController?.calendarView.titleLabelText = "ВИБЕРИТЕ ДАТУ ПРИБЫТИЯ"
      } else if dateController == arrivalDateController {
        arrivalDateController?.calendarView.titleLabelText = "ВИБЕРИТЕ ДАТУ ОТПРАВЛЕНИЯ"
      } else if dateController == visaCheckoutDateController {
        visaCheckoutDateController?.calendarView.titleLabelText = "ВИБЕРИТЕ ДАТУ ВХОДА В СТРАНУ"
      }
    }
    
    if let dateController = dateController {
      enableGestureRecognizers(isEnable: false)
      addAsChildViewController(dateController)
      //present(dateController!, animated: true, completion: nil)
    }
    
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
  
  fileprivate func makeAlert(type: AlertType) -> () -> () {
    return { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      guard let alertViewController = AlertViewController.storyboardInstance() else {
        return
      }
      
      if let alertView = alertViewController.view as? AlertView {
        alertView.alertType = type
      }
      
      strongSelf.addAsChildViewController(alertViewController)
    }
  }
  
  fileprivate func validationInfo() -> (isOk: Bool, competition: () -> ()) {
    
    // Check of city from / to
    guard let fromCity = dataSearch.fromCity, !fromCity.isEmpty else {
        return (isOk: false,
                competition: makeAlert(type: AlertType.error(subtitle: "Выберите город вылета")))
    }

    // Check of city from / to
    guard let toCity = dataSearch.toCity, !toCity.isEmpty else {
        return (isOk: false,
                competition: makeAlert(type: AlertType.error(subtitle: "Выберите город прилёта")))
    }

    
    // Check of departure date
    guard let _ = dataSearch.fromDepartureDate else {
      return (isOk: false,
              competition: makeAlert(type: AlertType.error(subtitle: "Выберите дату вылета или диапазон дат")))
    }
    
    return (isOk: true, competition: {})
    
  }
  
  func search() {
    let validation = validationInfo()
    
    guard validation.isOk else {
      validation.competition()
      return
    }
    
    let callback: (_ data: Any) -> () = { [weak self] json in
      guard let strongSelf = self else {
        return
      }
      
      //TODO: do something (for example auth)
      
      strongSelf.makeAlert(type: AlertType.airplane)()
    }

    
    RequestManager.post(urlPath: RequestManager.apiOrder,
                        params: dataSearch.dictionary(),
                        callback: callback)

  }

  func addListenersKeyboard() {
    NotificationCenter.default.addObserver(viewContent, selector: #selector(AirticketSearchView.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(viewContent, selector: #selector(AirticketSearchView.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  func removeListenersKeyboard() {
    NotificationCenter.default.removeObserver(viewContent, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(viewContent, name: .UIKeyboardWillHide, object: nil)
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
  
  func enableGestureRecognizers(isEnable: Bool) {
    viewContent.gestureRecognizers?.forEach {
      $0.isEnabled = isEnable
    }
  }

}

extension AirticketSearchViewController: AirticketSearchPickerDelegate {

  func showPicker(type: TypePicker) {
    viewContent.endEditing(true)
    currentTypePicker = type
    
    if let snapshotView = view.snapshotView(afterScreenUpdates: false) {
      pickerTitle.text = type.title
      pickerTitle.textColor = UIColor.black.withAlphaComponent(0.5)
      pickerTitle.font = UIFont(name: "FuturaPT-Book", size: 18)
      pickerTitle.alpha = 0
      pickerTitle.isHidden = false

      pickerTitle.frame = CGRect(x: 0, y: view.frame.height/3*2, width: view.frame.width, height: 50)

      picker.frame = CGRect(x: 0, y: view.frame.height/3*2, width: view.frame.width, height: view.frame.height/3)
      snapshotView.addSubview(picker)
      
      snapshotView.addSubview(pickerTitle)
      
      let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hidePicker))
      snapshotView.addGestureRecognizer(gestureRecognizer)
      
      view.addSubview(snapshotView)
      
      picker.alpha = 0
      picker.isHidden = false
      picker.reloadAllComponents()
      
      var currentRow = 0
      if currentTypePicker == .passenger {
        currentRow = dataSearch.numberOfPassengers.rawValue-1
      } else if currentTypePicker == .comfortClass {
        currentRow = dataSearch.comfortClass.rawValue-1
      } else if currentTypePicker == .visaDays {
        currentRow = dataSearch.visaDays.pickerRawValue
      }

      picker.selectRow(currentRow, inComponent: 0, animated: true)
      
      UIView.animate(withDuration: 0.3) {
        self.pickerTitle.alpha = 1
        self.picker.alpha = 1
      }
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
    } else if currentTypePicker == .comfortClass {
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
    } else if currentTypePicker == .comfortClass {
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
    } else if currentTypePicker == .comfortClass {
      dataSearch.comfortClass = ComfortClass.array[row]
      
      viewContent.comfortClassLabel.text = dataSearch.comfortClass.name
    } else if currentTypePicker == .visaDays {
      dataSearch.visaDays = VisaDays.array[row]
      
      viewContent.daysOfStayLabel.text = "\(dataSearch.visaDays.rawValue)"
    }
    
    hidePicker()
  }
  
  @objc fileprivate func hidePicker() {
  
    picker.superview?.removeFromSuperview()
    pickerTitle.removeFromSuperview()
    picker.removeFromSuperview()

    UIView.animate(withDuration: 0.3, animations: {
      self.pickerTitle.alpha = 0
      self.picker.alpha = 0
    }, completion: { (ok) in
      self.pickerTitle.isHidden = true
      self.picker.isHidden = true
    })
    
  }

}
