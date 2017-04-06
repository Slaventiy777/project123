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
    
    var calendarType: GTCalendarType! {
        didSet {
            let isResultViewWithOneDateViewHidden = calendarType == GTCalendarType.rangeOfDates
            resultViewWithOneDateView.isHidden = isResultViewWithOneDateViewHidden
            resultViewWithRangeOfDatesView.isHidden = !isResultViewWithOneDateViewHidden
            
            resultViewWithOneDateBottomLayout.priority = isResultViewWithOneDateViewHidden ? 250 : 1000
            resultViewWithRangeOfDatesBottomLayout.priority = isResultViewWithOneDateViewHidden ? 1000 : 250
        }
    }
    
    var selectedDates: [Date?] = [] {
        didSet {
            if calendarType == GTCalendarType.singleDate {
                resultViewWithOneDateView.update(date: selectedDates[0])
            } else {
                resultViewWithRangeOfDatesViewFrom.update(date: selectedDates[0])
                if selectedDates.count > 1 {
                    resultViewWithRangeOfDatesViewTo.update(date: selectedDates[1])
                }
            }
            
        }
    }
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBAction func toLastMonthAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func toNextMonthAction(_ sender: AnyObject) {
        
    }
    
    @IBOutlet weak var resultViewWithOneDateView: GTCalendarDayView!
    @IBOutlet weak var resultViewWithRangeOfDatesView: UIView!
    @IBOutlet weak var resultViewWithRangeOfDatesViewFrom: GTCalendarDayView!
    @IBOutlet weak var resultViewWithRangeOfDatesViewTo: GTCalendarDayView!
    // used for dynamic height superview
    @IBOutlet weak var resultViewWithOneDateBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var resultViewWithRangeOfDatesBottomLayout: NSLayoutConstraint!
    
    @IBOutlet weak var resultViewWithRangeOfDatesTitle: UILabel!
    @IBOutlet weak var resultViewWithRangeOfDatesTitleTopOffset: NSLayoutConstraint!
    @IBOutlet weak var resultViewWithRangeOfDatesTitleBottomOffset: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func submitAction(_ sender: AnyObject) {
        delegate.dates = calendar.selectedDates
    }
    
    public func updateView() {
        resultViewWithRangeOfDatesTitle.attributedText = self.setCharacterSpacig(string: (resultViewWithRangeOfDatesTitle.attributedText?.string)!)
        resultViewWithRangeOfDatesTitleTopOffset.constant = getActualSize(20)
        resultViewWithRangeOfDatesTitleBottomOffset.constant = getActualSize(13)

        submitButton.titleLabel?.font = self.getActualFont((submitButton.titleLabel?.font)!)
        
        titleLabel.font = self.getActualFont(titleLabel.font)
        
        resultViewWithOneDateView.updateSize()
        resultViewWithRangeOfDatesViewFrom.updateSize()
        resultViewWithRangeOfDatesViewTo.updateSize()
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
