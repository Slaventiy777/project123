//
//  AirticketSearchViewContent.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchView: UIView {
  fileprivate let animationDuration = 0.3
  
  var delegate: (SearchCityViewDelegate & AirticketSearchPickerDelegate)? {
    didSet {
      update()
    }
  }
  
  @IBOutlet weak var swapCityTextFieldsButton: UIButton!
  
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var toTextField: UITextField!

  @IBOutlet weak var fromSearchResultContainer: UIView!
  @IBOutlet weak var toSearchResultContainer: UIView!
  
  @IBOutlet weak var fromSearchResultContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var toSearchResultContainerHeight: NSLayoutConstraint!

  @IBOutlet weak var hideAdditionalInfoButton: UIButton!
  @IBOutlet weak var showAdditionalInfoButton: UIButton!
  
  @IBOutlet weak var additionalInfoLabel: UILabel!
  @IBOutlet weak var additionalInfoHeight: NSLayoutConstraint!
  
  @IBOutlet weak var countPeopleView: UIView!
  @IBOutlet weak var countPeopleLabel: UILabel!
  @IBOutlet weak var countPeopleImage: UIImageView!
  
  @IBOutlet weak var comfortClassLabel: UILabel!
  @IBOutlet weak var comfortClassImage: UIImageView!
  @IBOutlet weak var comfortClassPickerView: UIPickerView!
  
  @IBOutlet weak var suitcase0View: UIView!
  @IBOutlet weak var suitcase0Image: UIImageView!
  @IBOutlet weak var suitcase0CrossLabel: UILabel!
  @IBOutlet weak var suitcase0NumberLabel: UILabel!
  
  @IBOutlet weak var suitcase1View: UIView!
  @IBOutlet weak var suitcase1Image: UIImageView!
  @IBOutlet weak var suitcase1CrossLabel: UILabel!
  @IBOutlet weak var suitcase1NumberLabel: UILabel!
  
  @IBOutlet weak var suitcase2View: UIView!
  @IBOutlet weak var suitcase2Image: UIImageView!
  @IBOutlet weak var suitcase2CrossLabel: UILabel!
  @IBOutlet weak var suitcase2NumberLabel: UILabel!
  
  @IBOutlet weak var directFlightExternalView: UIView!
  @IBOutlet weak var directFlightInternalView: UIView!
  @IBOutlet weak var directFlightLabel: UILabel!
  
  @IBOutlet weak var visaCheckoutExternalView: UIView!
  @IBOutlet weak var visaCheckoutInternalView: UIView!
  @IBOutlet weak var visaCheckoutLabel: UILabel!
  
  @IBOutlet weak var dateVisaCheckoutButton: UIButton!
  
  @IBOutlet weak var daysOfStayLabel: UILabel!
  @IBOutlet weak var daysOfStayImage: UIImageView!
  
  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet weak var commentsHeight: NSLayoutConstraint!
  
  @IBOutlet weak var aditionalInfoView: UIView!
  
  
  var isCityResultHidden = true
  
  var fromSearchResultContainerContentHeight: CGFloat = 0.0 {
    didSet {
      if isCityResultHidden {
        return
      }
      
      fromSearchResultContainerHeight.constant = fromSearchResultContainerContentHeight
    }
  }
  
  var toSearchResultContainerContentHeight: CGFloat = 0.0 {
    didSet {
      if isCityResultHidden {
        return
      }

      toSearchResultContainerHeight.constant = toSearchResultContainerContentHeight
    }
  }
  
  var fromSearchCityText: String {
    set {
      fromTextField.text = newValue
      if let delegate = delegate {
        delegate.fromTextFieldDidChange()
      }
    }
    get {
      return fromTextField.text!
    }
  }

  var toSearchCityText: String {
    set {
      toTextField.text = newValue
      
      if let delegate = delegate {
        delegate.toTextFieldDidChange()
      }
    }
    
    get {
      return toTextField.text!
    }
  }
  
  fileprivate var comfortClass: ComfortClass = ComfortClass.economy {
    didSet {
      comfortClassLabel.text = comfortClass.name
    }
  }
  
//  func defultData() { }
  
  func updateInfo(_ model: AirticketSearchData) {
    
    countPeopleLabel.text = "\(model.countPassenger.rawValue)"
    comfortClassLabel.text = model.comfortClass.name
    
    switch model.baggage {
    case .zero:
      chooseSuitcase0()
    case .one:
      chooseSuitcase1()
    case .two:
      chooseSuitcase2()
    }
    
  }
  
  private func update() {
    addGestureRecognizerDismissKeyboard()
    
    commentsTextView.sizeToFit()
  }
  
  
  @IBAction func swapCityTextFieldsAction(_ button: UIButton) {
    isCityResultHidden = true
    toSearchResultContainerHeight.constant = 0
    fromSearchResultContainerHeight.constant = 0
    
    if let delegate = delegate {
      delegate.swapCityTextFieldsAction()
    }
  
    endEditing(true)
  }
  
  func showCityTextFieldsButton() {
    let show = fromSearchResultContainerHeight.constant == 0 ? 1 : 0
    
    UIView.animate(withDuration: 0.2,
                   animations: {
                    self.swapCityTextFieldsButton.alpha = CGFloat(show)
    })

  }

  //MARK: - UITextFieldDelegate
  
  @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
    isCityResultHidden = false

    if textField == toTextField {
      toSearchResultContainerHeight.constant = toSearchResultContainerContentHeight
    } else if textField == fromTextField {
      fromSearchResultContainerHeight.constant = fromSearchResultContainerContentHeight
      showCityTextFieldsButton()
    }
  }
  
  @IBAction func textFieldDidChange(_ textField: UITextField) {
    guard textField.text != nil else {
      return
    }

    if textField == toTextField {
      toSearchCityText = toTextField.text!
    } else if textField == fromTextField {
      fromSearchCityText = fromTextField.text!
      showCityTextFieldsButton()
    }
  }

  @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == toTextField {
      toSearchResultContainerHeight.constant = 0
      animateConstraintChanging()
    } else if textField == fromTextField {
      fromSearchResultContainerHeight.constant = 0
      animateConstraintChanging()
      showCityTextFieldsButton()
    }
    isCityResultHidden = true

  }
  
  private func animateConstraintChanging() {
    UIView.animate(withDuration: 0.2,
                   animations: {
                    self.layoutIfNeeded()
    })
  }
  
  
  //MARK: - UIViewController
  
  func addGestureRecognizerDismissKeyboard() {
    //return  //конфликтует с didSelectRowAt в AirticketSearchCityResultList
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    addGestureRecognizer(tap)
  }
  
  //Calls this function when the tap is recognized.
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    endEditing(true)
  }
  
  //MARK: - Outlets 
  
  @IBAction func chooseDispatchDate() {
    guard let delegate = delegate else {
      return
    }
    
    delegate.chooseDispatchDate()
  }
  
  @IBAction func chooseArrivalDate() {
    guard let delegate = delegate else {
      return
    }
    
    delegate.chooseArrivalDate()
  }
  
  // MARK: - Hide / Show additional info
  
  @IBAction func hideAdditionalInfo() {
    makeAdditionalInfo(isVisible: false)
  }
  
  @IBAction func showAdditionalInfo() {
    makeAdditionalInfo(isVisible: true)
  }
  
  private func makeAdditionalInfo(isVisible: Bool) {
    hideAdditionalInfoButton.isHidden = !isVisible
    showAdditionalInfoButton.isHidden = isVisible
    additionalInfoHeight.constant = aditionalInfoView.frame.height
    
    UIView.animate(withDuration: 1) {
      self.layoutIfNeeded()
    }
  }
  
  // MARK: - Count people
  
  @IBAction func chooseCountPeople() {
    delegate?.showPicker(type: .passenger)
  }
  
  // MARK: - Comfort class
  
  @IBAction func chooseComfortClass() {
    
    guard let delegate = delegate else {
      return
    }
    
    delegate.showPicker(type: .baggage)
    
//    UIView.animate(withDuration: animationDuration) {
//      self.comfortClassPickerView.alpha = self.comfortClassPickerView.alpha == 1 ? 0 : 1
//    }

    //comfortClassPickerView.frame = CGRect(x: 0, y: <#T##CGFloat#>, width: comfortClassPickerView.frame.size.width, height: comfortClassPickerView.frame.size.height)
    //comfortClassPickerView.reloadAllComponents()
  }

  // MARK: - Count suitcases
  
  private let suitcaseColor = UIColor(red: 0/255, green: 150/255, blue: 1, alpha: 1)
  
  //TODO: AWFUL! REFACTOR
  
  @IBAction func chooseSuitcase0() {
    suitcase0View.backgroundColor = suitcaseColor
    suitcase1View.backgroundColor = nil
    suitcase2View.backgroundColor = nil

    let selectedSuitcaseColor = UIColor.black
    let unselectedSuitcaseColor = UIColor.white
    applyColorForSuitcase(selectedSuitcaseColor, suitcase0View, suitcase0Image, suitcase0CrossLabel, suitcase0NumberLabel)
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase1View, suitcase1Image, suitcase1CrossLabel, suitcase1NumberLabel)
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase2View, suitcase2Image, suitcase2CrossLabel, suitcase2NumberLabel)
  }
  
  func applyColorForSuitcase(_ color: UIColor, _ suitcaseView: UIView, _ suitcaseImage: UIImageView, _ suitcaseCrossLabel: UILabel, _ suitcaseNumberLabel: UILabel) {
    suitcaseView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    suitcaseImage.image = suitcaseImage.image?.withRenderingMode(.alwaysTemplate)
    suitcaseImage.tintColor = color
    suitcaseCrossLabel.textColor = color
    suitcaseNumberLabel.textColor = color
  }
  
  @IBAction func chooseSuitcase1() {
    suitcase0View.backgroundColor = nil
    suitcase1View.backgroundColor = suitcaseColor
    suitcase2View.backgroundColor = nil
    
    let selectedSuitcaseColor = UIColor.black
    let unselectedSuitcaseColor = UIColor.white
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase0View, suitcase0Image, suitcase0CrossLabel, suitcase0NumberLabel)
    applyColorForSuitcase(selectedSuitcaseColor, suitcase1View, suitcase1Image, suitcase1CrossLabel, suitcase1NumberLabel)
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase2View, suitcase2Image, suitcase2CrossLabel, suitcase2NumberLabel)

  }
  
  @IBAction func chooseSuitcase2() {
    suitcase0View.backgroundColor = nil
    suitcase1View.backgroundColor = nil
    suitcase2View.backgroundColor = suitcaseColor
    
    let selectedSuitcaseColor = UIColor.black
    let unselectedSuitcaseColor = UIColor.white
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase0View, suitcase0Image, suitcase0CrossLabel, suitcase0NumberLabel)
    applyColorForSuitcase(unselectedSuitcaseColor, suitcase1View, suitcase1Image, suitcase1CrossLabel, suitcase1NumberLabel)
    applyColorForSuitcase(selectedSuitcaseColor, suitcase2View, suitcase2Image, suitcase2CrossLabel, suitcase2NumberLabel)

  }
  
  // MARK: - Direct flight
  
  @IBAction func chooseDirectFlight() {
    if let _ = directFlightInternalView.backgroundColor {
      directFlightInternalView.backgroundColor = nil
    } else {
      directFlightInternalView.backgroundColor = UIColor.blue
    }
  }
  
  // MARK: - Visa check-out
  
  @IBAction func chooseVisaCheckout() {
    if let _ = visaCheckoutInternalView.backgroundColor {
      visaCheckoutInternalView.backgroundColor = nil
    } else {
      visaCheckoutInternalView.backgroundColor = UIColor.blue
    }
  }
  
  // MARK: - Date visa check-out
  
  @IBAction func chooseDateVisaCheckout() {
    delegate?.chooseDateVisaCheckout()
  }
  
  // MARK: - Days of stay
  
  @IBAction func chooseDaysOfStay() {
    delegate?.showPicker(type: .visaDays)
  }
  
  //MARK: - Search
  
  @IBAction func search() {
    //TODO: fill data from view
//    let data = AirticketSearchData(fromCity: fromSearchCityText,
//                                   toCity: toSearchCityText,
//                                   fromDateDispatch: Date(),
//                                   toDateDispatch: Date(),
//                                   fromDateArrival: Date(),
//                                   toDateArrival: Date(),
//                                   comfortClass: .economy,
//                                   countPassenger: .one,
//                                   baggage: .one,
//                                   isDirectFlight: false,
//                                   isVisaCheckout: nil,
//                                   dateVisaCheckout: nil,
//                                   visaDays: nil,
//                                   comments: nil)
    delegate?.search()
  }
  
}

extension AirticketSearchView: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return ComfortClass.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return ComfortClass(rawValue: row+1)?.name
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    comfortClass = ComfortClass(rawValue: row+1)!
    UIView.animate(withDuration: animationDuration) {
      pickerView.alpha = 0
    }
  }
}

