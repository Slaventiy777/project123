//
//  RangeOfDatesCalendarController.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/12/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

class RangeOfDatesCalendarController: UIViewController, CalendarDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
  
  weak var delegate: AirticketSearchDateDelegate?
  var typeDate: TypeDate
  
  fileprivate let gregorian = Calendar(identifier: .gregorian)
  fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy--MM-dd"
    return formatter
  }()
  
  //MARK - GTCalendarDelegate
  
  var calendarView: GTCalendarView! {
    didSet {
      calendarView.delegate = self
      calendarView.calendarType = GTCalendarType.rangeOfDates
      //            self.view = calendarView
      calendarView.frame = self.view.bounds
      self.view.addSubview(calendarView)
    }
  }
  
  var dates: [Date] = [] {
    didSet {
      delegate?.setDates(type: typeDate, from: dateFrom, to: dateTo)
      close()
    }
  }
  
  convenience init() {
    self.init(type: .departure)
  }
  
  init(type: TypeDate) {
    typeDate = type
    super.init(nibName: nil, bundle: nil)
  }
  
  convenience required init?(coder aDecoder: NSCoder) {
    self.init()
    //super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.calendarView.calendar.allowsMultipleSelection = true
    self.calendarView.calendar.register(GTCalendarCell.self, forCellReuseIdentifier: "cell")
    self.calendarView.calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
    self.calendarView.updateView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)  //TODO: перенести в другое место
  }
  
  func close() {
    guard let parent = parent as? AirticketSearchViewController else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    delegate?.enableGestureRecognizers(isEnable: true)
    parent.removeAsChildViewController(self)
  }
  
  // MARK:- FSCalendarDataSource
  
  func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
    return cell
  }
  
  func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    self.configure(cell: cell, for: date, at: position)
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    return 2
  }
  
  // MARK:- FSCalendarDelegate
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendarView.calendar.frame.size.height = bounds.height
  }
  
  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
    return monthPosition == .current
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    self.selectDate(date: date)
    self.configureVisibleCells()
    self.calendarView.selectedDates = [self.dateFrom, self.dateTo]
  }
  
  func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
    self.deselectDate(date: date)
    self.configureVisibleCells()
    self.calendarView.selectedDates = [self.dateFrom, self.dateTo]
  }
  
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
    //        if self.gregorian.isDateInToday(date) {
    //            return [UIColor.red]
    //        }
    return [appearance.eventDefaultColor]
  }
  
  // MARK: - Private functions
  
  private func configureVisibleCells() {
    calendarView.calendar.visibleCells().forEach { (cell) in
      let date = calendarView.calendar.date(for: cell)
      let position = calendarView.calendar.monthPosition(for: cell)
      self.configure(cell: cell, for: date, at: position)
    }
  }
  
  private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
    let diyCell = (cell as! GTCalendarCell)
    // Custom today circle
    //diyCell.circleImageView.isHidden = true//!self.gregorian.isDateInToday(date)
    // Configure selection layer
    
    
    var selectionType = SelectionType.none
    
    if position == .current {
      cell.titleLabel.textColor = UIColor.white
    } else {
      cell.titleLabel.textColor = UIColor.lightGray
    }
    
    if calendarView.calendar.selectedDates.contains(date) {
      let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
      let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
      if calendarView.calendar.selectedDates.contains(date) {
        if calendarView.calendar.selectedDates.contains(previousDate) && calendarView.calendar.selectedDates.contains(nextDate) {
          selectionType = .middle
        }
        else if calendarView.calendar.selectedDates.contains(previousDate) && calendarView.calendar.selectedDates.contains(date) {
          selectionType = .rightBorder
        }
        else if calendarView.calendar.selectedDates.contains(nextDate) {
          selectionType = .leftBorder
          //            if
        }
        else {
          selectionType = .single
          cell.titleLabel.textColor = UIColor.white
        }
      }
    }
    
    
    
    if selectionType == .none {
      diyCell.selectionLayer.isHidden = true
      return
    }
    diyCell.selectionLayer.isHidden = false
    diyCell.selectionType = selectionType
    
}


//MARK - Mine

fileprivate var dateFrom: Date?
fileprivate var dateTo: Date?

private func selectDate(date: Date) {
  self.updateRangeOfSelectedDates(newDate: date)
  
  if dateTo == nil {
    self.configureVisibleCells()
    return
  }
  
  var dates: [Date] = []
  var datesDifference: Int = self.datesDifference(firstDate: dateFrom!, secondDate: dateTo!)!
  
  for i in 0...abs(datesDifference) {
    dates.insert(self.gregorian.date(byAdding: .day, value: datesDifference, to: dateFrom!)!, at: i)
    if datesDifference < 0 {
      datesDifference = datesDifference + 1
    } else {
      datesDifference = datesDifference - 1
    }
  }
  
  dates.forEach { (date) in
    calendarView.calendar.select(date, scrollToDate: false)
  }
  
}

func deselectDate(date: Date) {
  if dateFrom != nil && dateTo != nil {
    deselectRangeOfDates(dateStart: dateFrom!-1, dateEnd: dateTo!)
    dateFrom = nil
    dateTo = nil
    selectDate(date: date)
    calendarView.calendar.select(date)
  } else {
    dateFrom = nil
    dateTo = nil
    calendarView.calendar.deselect(date)
  }
}

  private func deselectRangeOfDates(dateStart: Date, dateEnd: Date) {
  let fmt = DateFormatter()
  fmt.dateFormat = "dd/MM/yyyy"
  let currentCalendar = Calendar.current
  var dateFromRemoveSelection = dateStart
  while dateFromRemoveSelection <= dateEnd {
    //            print(fmt.string(from: dateFromRemoveSelection))
    dateFromRemoveSelection = currentCalendar.date(byAdding: .day, value: 1, to: dateFromRemoveSelection)!
    calendarView.calendar.deselect(dateFromRemoveSelection)
  }
}

private func updateRangeOfSelectedDates(newDate: Date!) {
  if dateFrom == nil && dateTo == nil {
    dateFrom = newDate
  } else if dateFrom != nil && dateTo == nil {
    dateTo = newDate
    checkDates()
  } else if dateFrom != nil && dateTo != nil {
    deselectRangeOfDates(dateStart: dateFrom! - 1, dateEnd: dateTo!)
    dateFrom = newDate
    dateTo = nil
  }
}

private func checkDates() {
  if dateFrom != nil && dateTo != nil && dateTo! < dateFrom! {
    let bufferDate = dateFrom
    dateFrom = dateTo
    dateTo = bufferDate
  }
  //    if dateFrom == dateTo {
  //      dateTo = nil
  //    }
}

private func datesDifference(firstDate: Date, secondDate: Date) -> Int? {
  let calendar = NSCalendar.current as NSCalendar
  
  // Replace the hour (time) of both dates with 00:00
  let date1 = calendar.startOfDay(for: firstDate)
  let date2 = calendar.startOfDay(for: secondDate)
  
  let flags = NSCalendar.Unit.day
  let components = calendar.components(flags, from: date1, to: date2, options: [])
  
  return components.day
}




}
