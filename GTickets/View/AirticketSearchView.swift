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
  @IBOutlet weak var view: UIView!
  
  @IBOutlet weak var swapCityTextFieldsButton: UIButton!
  
  @IBOutlet weak var fromTextField: UITextField!
  @IBOutlet weak var toTextField: UITextField!
  
  @IBOutlet weak var fromSearchResultContainer: UIView!
  @IBOutlet weak var toSearchResultContainer: UIView!
  
  @IBOutlet weak var fromSearchResultContainerHeight: NSLayoutConstraint!
  @IBOutlet weak var toSearchResultContainerHeight: NSLayoutConstraint!
  
  @IBOutlet weak var departureButton: CityButton!
  @IBOutlet weak var returnButton: CityButton!
  
  @IBOutlet weak var additionalInfoButton: UIButton!
    @IBOutlet weak var additionalInfoButtonCenterY: NSLayoutConstraint!
  
  @IBOutlet weak var additionalInfoLabel: UILabel!
  @IBOutlet weak var additionalInfoHeight: NSLayoutConstraint!
  
  @IBOutlet weak var countPeopleView: UIView!
  @IBOutlet weak var countPeopleLabel: UILabel!
  @IBOutlet weak var countPeopleImage: UIImageView!
  
  @IBOutlet weak var comfortClassLabel: UILabel!
  @IBOutlet weak var comfortClassImage: UIImageView!
  
  @IBOutlet weak var suitcase0Button: UIButton!
  @IBOutlet weak var suitcase1Button: UIButton!
  @IBOutlet weak var suitcase2Button: UIButton!
  
  @IBOutlet weak var directFlightCheckbox: CheckboxView!
  @IBOutlet weak var visaCheckoutCheckbox: CheckboxView!
  
  @IBOutlet weak var visaCheckoutContainerHeight: NSLayoutConstraint!

  @IBOutlet weak var dateVisaCheckoutButton: UIButton!
  
  @IBOutlet weak var daysOfStayLabel: UILabel!
  @IBOutlet weak var daysOfStayImage: UIImageView!
  
  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet weak var commentsHeight: NSLayoutConstraint!
  
  @IBOutlet weak var aditionalInfoView: UIView!
  
  @IBOutlet weak internal var searchButton: UIButton!
  @IBOutlet weak var searchButtonBottomOffset: NSLayoutConstraint!
  
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
    
    if commentsTextView.text == nil || commentsTextView.text.isEmpty {
      commentsTextView.text = "Комментарий"
      commentsTextView.textColor = UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
      commentsTextView.textContainerInset = UIEdgeInsetsMake(19, 19, 19, 19)
    }
  }
  
  private func update() {
    addGestureRecognizerDismissKeyboard()
    
    commentsTextView.sizeToFit()
    
    directFlightCheckbox.onStateChangedAction = { _ in
      self.delegate?.chooseDirectFlight(self.directFlightCheckbox.isSelected)
    }
    
    visaCheckoutCheckbox.onStateChangedAction = { _ in
      
      let isVisible = self.visaCheckoutCheckbox.isSelected
      let visaCheckoutContainerHeight = isVisible ? self.suitcase0Button.frame.height + 15 : 0 //15 top offset of visaCheckoutContainer
      self.visaCheckoutContainerHeight.constant = visaCheckoutContainerHeight
      if self.additionalInfoHeight.constant != 0 {
        self.view.layoutIfNeeded()
        self.additionalInfoHeight.constant = self.aditionalInfoView.frame.height
      }

      self.endEditing(true)
      self.scrollView.layoutIfNeeded()
      self.scrollView.isScrollEnabled = false
      UIView.animate(withDuration: 0.3, animations: {
        self.view.layoutIfNeeded()
      }, completion: { _ in
        self.scrollView.isScrollEnabled = true
      })
      //delegate?.
    }
    
    updateFonts()
    
    let inset = getActualSize(23)
    toTextField.setPaddingPoints(inset)
    fromTextField.setPaddingPoints(inset)
    
  }
  
  private func updateFonts() {
    fromTextField.font = getActualFont(fromTextField.font!)
    toTextField.font = getActualFont(toTextField.font!)
    departureButton.titleLabel?.font = getActualFont((departureButton.titleLabel?.font)!)
    returnButton.titleLabel?.font = getActualFont((returnButton.titleLabel?.font)!)
    //    additionalInfoLabel.font = getActualFont(additionalInfoLabel.font)
    
    directFlightCheckbox.info.font = getActualFont(directFlightCheckbox.info.font)
    visaCheckoutCheckbox.info.font = getActualFont(visaCheckoutCheckbox.info.font)
    //    dateVisaCheckoutButton.titleLabel?.font = getActualFont((dateVisaCheckoutButton.titleLabel?.font)!)
    commentsTextView.font = getActualFont(commentsTextView.font!)
    suitcase0Button.titleLabel?.font = getActualFont((suitcase0Button.titleLabel?.font)!)
    suitcase1Button.titleLabel?.font = getActualFont((suitcase1Button.titleLabel?.font)!)
    suitcase2Button.titleLabel?.font = getActualFont((suitcase2Button.titleLabel?.font)!)
    comfortClassLabel.font = getActualFont(comfortClassLabel.font)
    countPeopleLabel.font = getActualFont(countPeopleLabel.font)
    searchButton.titleLabel?.font = getActualFont((searchButton.titleLabel?.font)!)
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
    guard textField.text != nil /*&& (textField.text?.characters.count)! > 3*/ else {
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
  
  fileprivate func animateConstraintChanging() {
    endEditing(true)
    scrollView.layoutIfNeeded()
    self.scrollView.isScrollEnabled = false
    UIView.animate(withDuration: 0.3, animations: {
      self.layoutIfNeeded()
    }) { _ in
      self.scrollView.isScrollEnabled = true
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
      updateCalendarButtonTextColor(text: textButton, button: departureButton)
      textButton = textButton.isEmpty ? "Туда" : textButton
      departureButton.setTitle(textButton, for: .normal)
    case .return:
      updateCalendarButtonTextColor(text: textButton, button: returnButton)
      textButton = textButton.isEmpty ? "Обратно" : textButton
      returnButton.setTitle(textButton, for: .normal)
    case .visa:
      updateCalendarButtonTextColor(text: textButton, button: dateVisaCheckoutButton)
      textButton = textButton.isEmpty ? "Дата входа" : textButton
      dateVisaCheckoutButton.setTitle(textButton, for: .normal)
    }
  }
  
  private func updateCalendarButtonTextColor(text: String, button: UIButton) {
    if text.isEmpty {
      button.setTitleColor(UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1), for: .normal)
    } else {
      button.setTitleColor(UIColor.white, for: .normal)
    }
  }
  
  // MARK: - Hide / Show additional info
  
  @IBAction func toggleAdditionalInfo() {
    let newState = !additionalInfoButton.isSelected
    additionalInfoButton.isSelected = newState
    makeAdditionalInfo(isVisible: newState)
  }
    
  private func makeAdditionalInfo(isVisible: Bool) {
    let additionalInfoButtonCenterYConst: CGFloat = 17

    UIView.animate(withDuration:0.3, animations: { () -> Void in
      let angleRotate = CGFloat(isVisible ? Double.pi : Double.pi*2)
      self.additionalInfoButton.transform = CGAffineTransform(rotationAngle: angleRotate)
    })

    additionalInfoButtonCenterY.constant = isVisible ? -additionalInfoButtonCenterYConst : additionalInfoButtonCenterYConst
    additionalInfoHeight.constant = isVisible ? aditionalInfoView.frame.height : 0
    aditionalInfoView.superview?.clipsToBounds = !isVisible
    
    if isVisible {
      scrollView.layoutIfNeeded()
      let bottomOffset = CGPoint(x: 0,
                                 y: scrollView.contentSize.height - scrollView.bounds.size.height)
      scrollView.setContentOffset(bottomOffset, animated: true)
    }
    
    endEditing(true)
    //scrollView.layoutIfNeeded()
    scrollView.isScrollEnabled = false
    UIView.animate(withDuration: 0.5, animations: {
      self.view.layoutIfNeeded()
      self.aditionalInfoView.alpha = isVisible ? 1 : 0
    }) { _ in
      self.scrollView.isScrollEnabled = true
    }
  }
  
  // MARK: - number of people
  
  @IBAction func chooseCountPeople() {
    delegate?.showPicker(type: .passenger)
  }
  
  // MARK: - Comfort class
  
  @IBAction func chooseComfortClass() {
    delegate?.showPicker(type: .comfortClass)
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
    
    suitcase0Button.setBackgroundColor()
    suitcase1Button.setBackgroundColor()
    suitcase2Button.setBackgroundColor()
    
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
  
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight = keyboardRectValue.height
      
      searchButtonBottomOffset.constant += keyboardHeight
      scrollView.layoutIfNeeded()
      
      let bottomOffset = CGPoint(x: 0,
                                 y: scrollView.contentSize.height - scrollView.bounds.size.height)
      scrollView.setContentOffset(bottomOffset, animated: true)
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight = keyboardRectValue.height
      
      searchButtonBottomOffset.constant -= keyboardHeight
      scrollView.layoutIfNeeded()
      
      delegate?.removeListenersKeyboard()
    }
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

extension AirticketSearchView: UITextViewDelegate {
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    if (textView.text == "Комментарий...") {
      textView.text = ""
      textView.textColor = .white
    }
    
    textView.becomeFirstResponder()
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if (textView.text == "") {
      textView.text = "Комментарий..."
      textView.textColor = .lightGray
    }
    
    textView.resignFirstResponder()
  }
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    delegate?.addListenersKeyboard()
    
    return true
  }
    
  func textViewDidChange(_ textView: UITextView) {
    let MIN_TEXT_VIEW_HEIGHT: CGFloat = 60
    let MAX_TEXT_VIEW_HEIGHT: CGFloat = 266
    
    let fixedWidth = textView.frame.size.width
    textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    
    let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    var newFrame = textView.frame
    newFrame.size = CGSize(width: max(newSize.width, fixedWidth),
                           height: min(max(newSize.height, MIN_TEXT_VIEW_HEIGHT), MAX_TEXT_VIEW_HEIGHT))

    if newFrame.height != textView.frame.height {
      scrollView.isScrollEnabled = false
      textView.frame = newFrame
      commentsHeight.constant = newFrame.height
      view.layoutIfNeeded()
      additionalInfoHeight.constant = aditionalInfoView.frame.height
      scrollView.isScrollEnabled = true
    }
    
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let limitCharacters = 300
    
    let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
    let numberOfChars = newText.characters.count
    return numberOfChars < limitCharacters
  }
  
}
