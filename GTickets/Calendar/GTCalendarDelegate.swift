//
//  CalendarDelegate.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/12/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

protocol CalendarDelegate {
    var calendarView: GTCalendarView! { get set }
//    init(calendarView: GTCalendarView!)
  
  var dates: [Date] { get set }

}
