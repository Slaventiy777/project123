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

  @IBOutlet weak var departureButton: UIButton!
  @IBOutlet weak var returnButton: UIButton!

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

  fileprivate var comfortClass: ComfortClass = ComfortClass.economy {
    didSet {
      comfortClassLabel.text = comfortClass.name
    }
  }

  func updateInfo(_ model: AirticketSearchData) {
    fromTextField.text = model.fromCity
    toTextField.text = model.toCity
    
    setTitleDates(type: .departure, from: model.fromDepartureDate, to: model.toDepartureDate)
    setTitleDates(type: .return, from: model.fromReturnDate, to: model.toReturnDate)
    
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
    
    directFlightCheckbox.isSelected = model.isDirectFlight
    visaCheckoutCheckbox.isSelected = model.isVisaCheckout
    
    setTitleDates(type: .visa, from: model.dateVisaCheckout, to: nil)
    daysOfStayLabel.text = "\(model.visaDays.rawValue)"
    commentsTextView.text = model.comments
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
    
    delegate?.swapCityTextFieldsAction()
    
    endEditing(true)
  }

  func showCityTextFieldsButton() {
    let show: CGFloat = fromSearchResultContainerHeight.constant == 0 ? 1.0 : 0.0
    
    UIView.animate(withDuration: 0.2) {
      self.swapCityTextFieldsButton.alpha = show
    }
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
      let toSearchCityText = toTextField.text ?? ""
      delegate?.toTextFieldDidChange(toSearchCityText)
    } else if textField == fromTextField {
      let fromSearchCityText = fromTextField.text ?? ""
      delegate?.fromTextFieldDidChange(fromSearchCityText)
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
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }


  //MARK: - UIViewController

  func addGestureRecognizerDismissKeyboard() {
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                             action: #selector(dismissKeyboard))
    
    tap.delegate = self
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

  func setTitleDates(type: TypeDate, from: Date?, to: Date?) {
    var textButton = ""
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    dateFormatter.locale = Locale(identifier: "en_GB")
    
    var fromString = ""
    if let from = from {
      fromString = dateFormatter.string(from: from)
        
      textButton = fromString
    }
    
    var toString = ""
    if let to = to {
      toString = dateFormatter.string(from: to)
    
        if !textButton.isEmpty {
          textButton += " - \(toString)"
        }
    }

    switch type {
    case .departure:
      textButton = textButton.isEmpty ? "Туда" : textButton
      departureButton.setTitle(textButton, for: .normal)
    case .return:
      textButton = textButton.isEmpty ? "Обратно" : textButton
      returnButton.setTitle(textButton, for: .normal)
    case .visa:
      textButton = textButton.isEmpty ? "???" : textButton
      dateVisaCheckoutButton.setTitle(textButton, for: .normal)
    }
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
    chooseSuitcase(.zero)
  }

  @IBAction func chooseSuitcase1() {
    chooseSuitcase(.one)
  }

  @IBAction func chooseSuitcase2() {
    chooseSuitcase(.two)
  }
  
    private func chooseSuitcase(_ baggage: Baggage) {
        var isSelected0 = false
        var isSelected1 = false
        var isSelected2 = false
        
        switch baggage {
        case .zero:
            isSelected0 = true
        case .one:
            isSelected1 = true
        case .two:
            isSelected2 = true
        }
      
        suitcase0Button.isSelected = isSelected0
        suitcase1Button.isSelected = isSelected1
        suitcase2Button.isSelected = isSelected2
      
        delegate?.chooseBaggage(baggage)
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

extension AirticketSearchView: UIGestureRecognizerDelegate {
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    guard let touchView = touch.view else {
      return true
    }
    
    if touchView.isDescendant(of: fromSearchResultContainer) ||
      touchView.isDescendant(of: toSearchResultContainer) {
      return false
    }
    
    return true
  }
  
}
