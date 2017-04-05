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
        selectionLayer.fillColor = UIColor.clear.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.circleImageView.frame = self.contentView.bounds
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        if selectionType == .middle {
            self.selectionLayer.frame = CGRect(x: self.contentView.bounds.origin.x,
                                               y: 6,
                                               width: self.contentView.bounds.size.width,
                                               height: self.contentView.bounds.size.height - 6*2)//27

            self.selectionLayer.fillColor = UIColor.init(colorLiteralRed: 0, green: 150/255, blue: 1, alpha: 0.9).cgColor
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            
            self.titleLabel.textColor = UIColor.white
            
            
        } else if selectionType == .leftBorder {
//            selectionLayer = newSelectionLayer()

            self.updateMiddleSelectionLayer()
            self.selectionLayer.fillColor = UIColor.white.cgColor
            self.selectionLayer.path =
                UIBezierPath(ovalIn: CGRect(x: (contentView.frame.width - shapeLayer.bounds.width) / 2,
                                            y: (contentView.frame.height - shapeLayer.bounds.height) / 2,
                                        width: shapeLayer.bounds.width,
                                        height: shapeLayer.bounds.height)).cgPath

 //         selectionLayer = newSelectionLayer()
            
        } else if selectionType == .rightBorder {
            self.updateMiddleSelectionLayer()
            self.selectionLayer.fillColor = UIColor.white.cgColor
            self.selectionLayer.path =
                UIBezierPath(ovalIn: CGRect(x: (contentView.frame.width - shapeLayer.bounds.width) / 2,
                                            y: (contentView.frame.height - shapeLayer.bounds.height) / 2,
                                            width: shapeLayer.bounds.width,
                                            height: shapeLayer.bounds.height)).cgPath
 
//            selectionLayer = newSelectionLayer()
            
        } else if selectionType == .single {
            self.selectionLayer.fillColor = UIColor.white.cgColor
//            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path =
//                UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath

            UIBezierPath(ovalIn: CGRect(x: (contentView.frame.width - shapeLayer.bounds.width) / 2,
                                        y: (contentView.frame.height - shapeLayer.bounds.height) / 2,
                                        width: shapeLayer.bounds.width,
                                        height: shapeLayer.bounds.height)).cgPath
                
//            UIBezierPath(roundedRect: shapeLayer.bounds, cornerRadius: shapeLayer.bounds.size.width*0.5).cgPath
//            CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
//                cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
        }
    }
    
    private func newSelectionLayer () -> CAShapeLayer {
        let superLayer = CAShapeLayer()
        superLayer.actions = ["hidden": NSNull()]
        superLayer.frame = self.contentView.bounds

        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.frame = self.contentView.bounds
        circleLayer.path =
            UIBezierPath(ovalIn: CGRect(x: (contentView.frame.width - shapeLayer.bounds.width) / 2,
                                        y: (contentView.frame.height - shapeLayer.bounds.height) / 2,
                                        width: shapeLayer.bounds.width,
                                        height: shapeLayer.bounds.height)).cgPath
        superLayer.insertSublayer(circleLayer, at: 0)
        
        let middleSelectionLayer = CAShapeLayer()
        middleSelectionLayer.fillColor = UIColor.init(colorLiteralRed: 0, green: 150/255, blue: 1, alpha: 0.9).cgColor
        let x = selectionType == .rightBorder ? 0 : self.contentView.bounds.size.width/2
        middleSelectionLayer.frame = CGRect(x: x,
                                            y: 6,
                                            width: self.contentView.bounds.size.width/2,
                                            height: self.contentView.bounds.size.height - 6*2)
        middleSelectionLayer.path = UIBezierPath(rect: middleSelectionLayer.bounds).cgPath
        superLayer.insertSublayer(middleSelectionLayer, below: circleLayer)
        
        return superLayer
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
        self.middleSelectionLayer.frame = CGRect(x: x,
                                                 y: 6,
                                                 width: self.contentView.bounds.size.width/2,
                                                 height: self.contentView.bounds.size.height - 6*2)
        self.middleSelectionLayer.path = UIBezierPath(rect: middleSelectionLayer.bounds).cgPath
        
        //        if middleSelectionLayer.superlayer != nil {
        //            middleSelectionLayer.removeFromSuperlayer()
        //        }
        
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
