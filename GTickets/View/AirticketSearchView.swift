//
//  AirticketSearchViewContent.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchView: UIView {
  
  var delegate: SearchCityViewDelegate! {
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
  
  private var previousAditionalInfoHeight: CGFloat = 330
  
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
      delegate.fromTextFieldDidChange()
    }
    get {
      return fromTextField.text!
    }
  }

  var toSearchCityText: String {
    set {
      toTextField.text = newValue
      delegate.toTextFieldDidChange()
    }
    get {
      return toTextField.text!
    }
  }
  
  func updateInfo(_ model: AirticketSearchData) {
    
    countPeopleLabel.text = "\(model.countPeople.rawValue)"
    comfortClassLabel.text = model.comfortClass.name
    
    switch model.suitcases {
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
  }
  
  
  @IBAction func swapCityTextFieldsAction(_ button: UIButton) {
    isCityResultHidden = true
    toSearchResultContainerHeight.constant = 0
    fromSearchResultContainerHeight.constant = 0
    delegate.swapCityTextFieldsAction()
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
  
  // MARK: - Hide / Show additional info
  
  @IBAction func hideAdditionalInfo() {
    makeAdditionalInfo(isVisible: false)
  }
  
  @IBAction func showAdditionalInfo() {
    makeAdditionalInfo(isVisible: true)
  }
  
  private func makeAdditionalInfo(isVisible: Bool) {
    hideAdditionalInfoButton.isHidden = isVisible ? false : true
    showAdditionalInfoButton.isHidden = isVisible ? true : false
    
    let prevConstant = additionalInfoHeight.constant
    additionalInfoHeight.constant = previousAditionalInfoHeight
    previousAditionalInfoHeight = prevConstant
    
    layoutIfNeeded()    
  }
  
  // MARK: - Count people
  
  @IBAction func chooseCountPeople() {
  }
  
  // MARK: - Comfort class
  
  @IBAction func chooseComfortClass() {
  }

  // MARK: - Count suitcases
  
  @IBAction func chooseSuitcase0() {
    suitcase0View.backgroundColor = UIColor.blue
    suitcase1View.backgroundColor = nil
    suitcase2View.backgroundColor = nil
  }
  
  @IBAction func chooseSuitcase1() {
    suitcase0View.backgroundColor = nil
    suitcase1View.backgroundColor = UIColor.blue
    suitcase2View.backgroundColor = nil
  }
  
  @IBAction func chooseSuitcase2() {
    suitcase0View.backgroundColor = nil
    suitcase1View.backgroundColor = nil
    suitcase2View.backgroundColor = UIColor.blue
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
  }
  
  // MARK: - Days of stay
  
  @IBAction func chooseDaysOfStay() {
  }
  
}

