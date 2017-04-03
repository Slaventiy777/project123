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
  
  @IBOutlet weak var additionalInfoHeight: NSLayoutConstraint!
  
  private var previousAditionalInfoHeight: CGFloat = 560
  
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
  
}

