//
//  ExampleController.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/12/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

class ExampleController: UIViewController {
    
    @IBAction func choseOneDateAction(_ sender: AnyObject) {
        let calendarView: GTCalendarView = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarController").view as! GTCalendarView
        let controller: OneDateCalendarController = OneDateCalendarController()
        controller.calendarView = calendarView
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func choseRangeOfDatesAction(_ sender: AnyObject) {
        let calendarView: GTCalendarView = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarController").view as! GTCalendarView
        let controller: RangeOfDatesCalendarController = RangeOfDatesCalendarController()
        controller.calendarView = calendarView
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
