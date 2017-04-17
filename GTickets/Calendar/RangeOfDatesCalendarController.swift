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
      if dates.count == 1 {
        delegate?.setDates(type: typeDate, from: dates[0], to: nil)
      } else if dates.count >= 2 {
        delegate?.setDates(type: typeDate, from: dates[0], to: dates[dates.count - 1])
      }
      
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
    
    let scopeGesture = UIPanGestureRecognizer(target: self.calendarView.calendar, action: #selector(self.calendarView.calendar.handleScopeGesture(_:)));
    self.calendarView.calendar.addGestureRecognizer(scopeGesture)
    
    self.calendarView.updateView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)  //TODO: перенести в другое место
    applyNavBarSettings()
  }
  
  private func applyNavBarSettings() {
//    navigationItem.title = "ЧТО-ТО ТАМ ВСЕГДА МОЖНО ДОПИСАТЬ"
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    navigationController?.navigationBar.barTintColor = UIColor.clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    //navigationController?.navigationBar.shadowImage = UIImage()
    //navigationController?.navigationBar.alpha = 0.5
    
    navigationController?.navigationBar.layer.masksToBounds = false
    navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    navigationController?.navigationBar.layer.shadowOpacity = 0.99
    navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5.0)
    navigationController?.navigationBar.layer.shadowRadius = 5
    
    navigationController?.navigationBar.isTranslucent = true
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ЗАКРЫТЬ", style: .plain, target: self, action: #selector(close))
  }
  
  func close() {
    navigationController?.dismiss(animated: true, completion: nil)
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
    if position == .current {
      
      var selectionType = SelectionType.none
      
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
          }
          else {
            selectionType = .single
          }
        }
      }
      else {
        selectionType = .none
      }
      if selectionType == .none {
        diyCell.selectionLayer.isHidden = true
        return
      }
      diyCell.selectionLayer.isHidden = false
      diyCell.selectionType = selectionType
      
    } else {
      //            diyCell.circleImageView.isHidden = true
      diyCell.selectionLayer.isHidden = true
    }
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
      let fmt = DateFormatter()
      fmt.dateFormat = "dd/MM/yyyy"
      let currentCalendar = Calendar.current
      var dateFromRemoveSelection = date - 1
      while dateFromRemoveSelection <= dateTo! {
        //            print(fmt.string(from: dateFromRemoveSelection))
        dateFromRemoveSelection = currentCalendar.date(byAdding: .day, value: 1, to: dateFromRemoveSelection)!
        calendarView.calendar.deselect(dateFromRemoveSelection)
      }
      
      if date == dateFrom {
        dateTo = nil
        //            } else if date == dateTo {
        //                dateTo = dateTo! - 1
      } else {
        dateTo = date
      }
      calendarView.calendar.select(date)
    } else {
      dateFrom = nil
      dateTo = nil
      calendarView.calendar.deselect(date)
    }
    
  }
  
  private func updateRangeOfSelectedDates(newDate: Date!) {
    if dateFrom == nil && dateTo == nil {
      self.dateFrom = newDate
    } else if dateFrom == nil && dateTo != nil {
      self.dateFrom = newDate
      self.checkDates()
    } else if dateFrom != nil && dateTo == nil {
      self.dateTo = newDate
      self.checkDates()
    } else if dateFrom != nil && dateTo != nil {
      if newDate! < dateFrom! {
        dateFrom = newDate
      } else {
        dateTo = newDate
      }
    }
  }
  
  private func checkDates() {
    if dateFrom != nil && dateTo != nil && dateTo! < dateFrom! {
      let bufferDate = dateFrom
      dateFrom = dateTo
      dateTo = bufferDate
    }
    if dateFrom == dateTo {
      dateTo = nil
    }
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
