//
//  AirticketSearchViewContent.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchViewContent: UIView {
  
  @IBOutlet weak var fromField: FindTextField!
  @IBOutlet weak var toField: FindTextField!
  @IBOutlet weak var fromSearchResultView: UIView!
  @IBOutlet weak var toSearchResultView: UIView!
  
  @IBOutlet weak var toFieldTopOffset: NSLayoutConstraint!
    
  func update() {
    fromField.updateField()
    toField.updateField()
    
    setTopOffsetToField(isDefault: false)
  }
  
  func setTopOffsetToField(isDefault: Bool) {
    let defaultOffset: CGFloat = 25.0
    
    if isDefault {
      fromSearchResultView.isHidden = true
      
      toFieldTopOffset.constant = defaultOffset
    } else {
      let fromSearchResultOffset = fromField.frame.maxY - fromSearchResultView.frame.minY
      
      fromSearchResultView.isHidden = false
      
      toFieldTopOffset.constant = defaultOffset +
                                  fromSearchResultView.frame.height +
                                  fromSearchResultOffset
    }
  }

  
  //MARK: - UITextFieldDelegate
  
  @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
    if !(textField.text?.isEmpty)! {
      //updateDataSource()
    }
    //showTableView(alpha: 1)
  }
  
  @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
    //showTableView(alpha: 0)
  }
  
  @IBAction func textFieldDidChange(_ textField: UITextField) {
    //updateDataSource()
  }
  
  
  //MARK: - UIViewController
  
  func addGestureRecognizerDismissKeyboard() {
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
  
}

