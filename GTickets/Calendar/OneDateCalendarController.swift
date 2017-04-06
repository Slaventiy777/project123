//
//  CalendarController.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/11/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

class OneDateCalendarController: UIViewController, CalendarDelegate, FSCalendarDataSource, FSCalendarDelegate {
  
  //MARK: GTCalendarDelegate
  var calendarView: GTCalendarView! {
    didSet {
      calendarView.delegate = self
      calendarView.calendarType = GTCalendarType.singleDate
      //            self.view = calendarView  // was exeption
      calendarView.frame = self.view.bounds
      self.view.addSubview(calendarView)
    }
  }
  
  var dates: [Date] = [] {
    didSet {
      
    }
  }
  
  //MARK - FSCalendarDataSource, FSCalendarDelegate
  fileprivate let gregorian = Calendar(identifier: .gregorian)
  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy--MM-dd"
    return formatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.calendarView.updateView()
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
    self.calendarView.selectedDates = [date]
  }
}
