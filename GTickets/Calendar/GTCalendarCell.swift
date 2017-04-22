//
//  GT.swift
//  FSCalendarSwiftExample
//
//  Created by Marharyta Lytvynenko on 3/12/17.
//  Copyright © 2017 wenchao. All rights reserved.
//

import Foundation

//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit

//enum SelectionType : Int { 
//    case none
//    case single
//    case leftBorder
//    case middle
//    case rightBorder
//}

class GTCalendarCell: FSCalendarCell {
    
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
      
//        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
//        self.contentView.insertSubview(circleImageView, at: 0)
//        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.init(colorLiteralRed: 0, green: 150/255, blue: 1, alpha: 0.9).cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
//      self.circleImageView.frame = self.contentView.bounds
      self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
      self.selectionLayer.frame = self.contentView.bounds
      self.titleLabel.textColor = UIColor.white
      
      let offset: CGFloat = 4
      let selectionLayerHeight = self.selectionLayer.frame.width / 2 - offset*2
      let roundedRect = CGRect(x: 0, y: offset, width: self.selectionLayer.bounds.width, height: self.selectionLayer.bounds.height - offset*2)
      
      if selectionType == .middle {
        self.selectionLayer.path = UIBezierPath(rect: roundedRect).cgPath
      }
      else if selectionType == .leftBorder {
        self.selectionLayer.path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: selectionLayerHeight)).cgPath
      }
      else if selectionType == .rightBorder {
        self.selectionLayer.path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: selectionLayerHeight)).cgPath
      }
      else if selectionType == .single {
        let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width) - offset*2
        self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
      }

    }
  
    override func configureAppearance() {
        super.configureAppearance()
        self.eventIndicator.isHidden = true
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
