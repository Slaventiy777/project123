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
  
  weak var delegate: (SearchCityViewDelegate & AirticketSearchPickerDelegate)? {
    didSet {
      update()
    }
  }
  
  @IBOutlet weak var scrollView: UIScrollView!
  
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
  
  @IBOutlet weak var suitcase0Button: UIButton!
  @IBOutlet weak var suitcase1Button: UIButton!
  @IBOutlet weak var suitcase2Button: UIButton!
  
  @IBOutlet weak var directFlightCheckbox: CheckboxView!
  @IBOutlet weak var visaCheckoutCheckbox: CheckboxView!
  
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
  
  func updateInfo(_ model: AirticketSearchData) {
    
    countPeopleLabel.text = "\(model.numberOfPassengers.rawValue)"
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
    
    directFlightCheckbox.onStateChangedAction = { _ in
      self.delegate?.chooseDirectFlight(self.directFlightCheckbox.isSelected)
    }
    
    visaCheckoutCheckbox.onStateChangedAction = { _ in
      //delegate?.
    }

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
    delegate?.chooseDispatchDate()
  }
  
  @IBAction func chooseArrivalDate() {
    delegate?.chooseArrivalDate()
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
    additionalInfoHeight.constant = isVisible ? aditionalInfoView.frame.height : 0
    
//    UIView.animate(withDuration: 1) {
//      self.layoutIfNeeded()
//    }
  }
  
  // MARK: - number of people
  
  @IBAction func chooseCountPeople() {
    delegate?.showPicker(type: .passenger)
  }
  
  // MARK: - Comfort class
  
  @IBAction func chooseComfortClass() {
    delegate?.showPicker(type: .baggage)
  }

  // MARK: - Count suitcases
  
  private let suitcaseColor = UIColor(red: 0 / 255, green: 150 / 255, blue: 1, alpha: 1)
  
  @IBAction func chooseSuitcase0() {
    suitcase0Button.isSelected = !suitcase0Button.isSelected
    suitcase1Button.isSelected = false
    suitcase2Button.isSelected = false
    delegate?.chooseBaggage(.zero)
  }
  
  @IBAction func chooseSuitcase1() {
    suitcase1Button.isSelected = !suitcase1Button.isSelected
    suitcase0Button.isSelected = false
    suitcase2Button.isSelected = false
    delegate?.chooseBaggage(.one)
  }
  
  @IBAction func chooseSuitcase2() {
    suitcase2Button.isSelected = !suitcase2Button.isSelected
    suitcase0Button.isSelected = false
    suitcase1Button.isSelected = false
    delegate?.chooseBaggage(.two)
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
    delegate?.search()
  }
  
}


