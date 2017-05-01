//
//  CalendarView.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/11/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

enum GTCalendarType {
  case singleDate, rangeOfDates
}

class GTCalendarView: UIView {
  //    @IBOutlet weak var calendarView: UIView!
  
  
  var delegate: CalendarDelegate! {
    didSet {
      self.calendar.delegate = delegate as! FSCalendarDelegate?
      self.calendar.dataSource = delegate as! FSCalendarDataSource?
    }
  }
  
  var calendarType: GTCalendarType!
  
  var selectedDates: [Date?] = [] {
    didSet {
      resultTitle.attributedText = nil
      if calendarType == GTCalendarType.singleDate {
        if let date = selectedDates[0] {
          resultTitle.attributedText = attributedString(mainString: "дата входа в страну \(date.string())".uppercased(), dates: [date])
        }
      } else {
        let dateFrom = selectedDates[0]
        let dateTo = selectedDates[1]
        
        if dateFrom != nil && dateTo == nil {
          if let date = selectedDates[0] {
            resultTitle.attributedText = attributedString(mainString: "Мы подберем для Вас лучшие варианты на \(date.string())".uppercased(), dates: [date])
          }
        } else if dateFrom != nil && dateTo != nil {
          resultTitle.attributedText = attributedString(mainString: "Мы подберем для Вас лучшие направления в период с \(dateFrom!.string()) по \(dateTo!.string())".uppercased(), dates: [dateFrom!, dateTo!])
        }
      }
      
    }
  }
  
  var titleLabelText: String = "" {
    didSet {
      titleLabel.text = titleLabelText
    }
  }
  
  @IBOutlet weak var calendar: FSCalendar!
  
  @IBAction func toLastMonthAction(_ sender: AnyObject) {
    
  }
  
  @IBAction func toNextMonthAction(_ sender: AnyObject) {
    
  }
  
  // used for dynamic height superview
  @IBOutlet weak var resultTitle: UILabel!
  
  @IBOutlet weak var submitButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBAction func submitAction(_ sender: AnyObject) {
    delegate.dates = calendar.selectedDates
  }
  
  public func updateView() {
    resultTitle.font = getActualFont(resultTitle.font)
    submitButton.titleLabel?.font = self.getActualFont((submitButton.titleLabel?.font)!)
    titleLabel.font = self.getActualFont(titleLabel.font)
  }
  
  func attributedString(mainString: String, dates: [Date]) -> NSAttributedString {
    let attribute = NSMutableAttributedString.init(string: mainString)
    
    dates.forEach {
      let dateString = $0.string()
      let range = (mainString as NSString).range(of: dateString)
      attribute.addAttribute(NSForegroundColorAttributeName, value: UIColor.init(red: 0, green: 150/255, blue: 255/255, alpha: 1) , range: range) //blue
    }
    
    return attribute
  }
  
  func getActualFont(_ font: UIFont) -> UIFont! {
    let fontName = font.fontName
    return UIFont(name: fontName, size: getActualSize(font.pointSize) )!
  }
  
  func getActualSize(_ size: CGFloat) -> CGFloat {
    return size / 414 * UIScreen.main.bounds.size.width
  }
  
  func setCharacterSpacig(string:String) -> NSMutableAttributedString {
    let attributedStr = NSMutableAttributedString(string: string)
    attributedStr.addAttribute(NSKernAttributeName, value: -0.5, range: NSMakeRange(0, attributedStr.length))
    attributedStr.addAttribute(NSFontAttributeName, value: UIFont(name:"FuturaPT-Medium", size:getActualSize(14))!, range: NSMakeRange(0, attributedStr.length))
    return attributedStr
  }
  
}
