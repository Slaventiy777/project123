//
//  CalendarController.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/11/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

class OneDateCalendarController: UIViewController, CalendarDelegate, FSCalendarDataSource, FSCalendarDelegate {
  
  weak var delegate: AirticketSearchDateDelegate?
  var typeDate: TypeDate
  
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
      if dates.count == 1 {
        delegate?.setDates(type: typeDate, from: dates[0], to: nil)
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
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
    self.calendarView.selectedDates = [date]
  }
}
