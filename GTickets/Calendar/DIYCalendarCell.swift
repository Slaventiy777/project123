//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    fileprivate weak var middleSelectionLayer: CAShapeLayer!
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
        self.contentView.insertSubview(circleImageView, at: 0)
        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.clear.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.frame = CGRect(x: self.contentView.bounds.origin.x, y: 3, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height - 3*2)
            self.selectionLayer.fillColor = UIColor.init(colorLiteralRed: 0, green: 150/255, blue: 1, alpha: 0.9).cgColor
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.updateMiddleSelectionLayer()
            self.selectionLayer.fillColor = UIColor.black.cgColor
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            
        } else if selectionType == .rightBorder {
            self.updateMiddleSelectionLayer()
            self.selectionLayer.fillColor = UIColor.black.cgColor
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath

        } else if selectionType == .single {
            self.selectionLayer.fillColor = UIColor.black.cgColor
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
        }      
    }
    
    func updateMiddleSelectionLayer() {
        if self.middleSelectionLayer == nil {
            let middleSelectionLayer = CAShapeLayer()
            selectionLayer.actions = ["hidden": NSNull()]
            middleSelectionLayer.fillColor = UIColor.init(colorLiteralRed: 0, green: 150/255, blue: 1, alpha: 0.9).cgColor
            self.contentView.layer.insertSublayer(middleSelectionLayer, below: self.selectionLayer)
            self.middleSelectionLayer = middleSelectionLayer
        }
        
        let x = selectionType == .rightBorder ? 0 : self.contentView.bounds.size.width/2
        self.middleSelectionLayer.frame = CGRect(x: x, y: 3, width: self.contentView.bounds.size.width/2, height: self.contentView.bounds.size.height - 3*2)
        self.middleSelectionLayer.path = UIBezierPath(rect: middleSelectionLayer.bounds).cgPath
        
//        if middleSelectionLayer.superlayer != nil {
//            middleSelectionLayer.removeFromSuperlayer()
//        }
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
