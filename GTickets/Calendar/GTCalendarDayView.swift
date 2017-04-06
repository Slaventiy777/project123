//
//  CalendarDayView.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/11/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

class GTCalendarDayView: UIView {
    fileprivate let titleFont = UIFont(name: "FuturaPT-Medium", size: 13)!
    fileprivate let _titleBottomOffset = 8
    fileprivate let dayDateFont = UIFont(name: "FuturaPT-Medium", size: 18)!
    fileprivate let dayOfWeekFont = UIFont(name: "FuturaPT-Medium", size: 18)!
    
    @IBOutlet weak var title: UILabel?
    @IBOutlet weak var titleBottomOffset: NSLayoutConstraint?
    
    @IBOutlet weak var dayDate: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy--MM-dd"    //TODO: change dateFormat
        return formatter
    }()
    
    fileprivate var date: Date? {
        didSet {
            if date == nil {
                self.dayDate.text = "-"
                self.dayOfWeek.text = "-"
                return
            }
            
            formatter.dateFormat = "dd"
            let day = formatter.string(from: date!)
            formatter.dateFormat = "MMMM"
            let month = formatter.string(from: date!)
            self.dayDate.text = (day + month).uppercased()
            formatter.dateFormat = "EEEE"
            let dayOfWeek = formatter.string(from: date!)
            self.dayOfWeek.text = dayOfWeek
        }
    }
    
    func update(date: Date?) {
        self.date = date
    }
    
    func updateSize() {
        dayDate.font = getActualFont(dayDateFont)
        dayOfWeek.font = getActualFont(dayOfWeekFont)
        if title != nil {
            title?.font = getActualFont((titleFont))
        }
        if titleBottomOffset != nil {
            titleBottomOffset?.constant = CGFloat(getActualSize(CGFloat(_titleBottomOffset)))
        }
    }
    
    func getActualFont(_ font: UIFont) -> UIFont! {
        let fontName = font.fontName
        return UIFont(name: fontName, size: getActualSize(font.pointSize))!
    }

    func getActualSize(_ size: CGFloat) -> CGFloat {
        return size / 414 * UIScreen.main.bounds.size.width
    }

}
