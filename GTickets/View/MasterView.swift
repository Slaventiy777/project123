//
//  MasterView.swift
//  GTickets
//
//  Created by Slava on 3/20/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class MasterView: UIView {
  
  let deltaX: CGFloat = 100.0
  let deltaY: CGFloat = 100.0
  
  func updateView() {
    makeGradientLayer()
    
    let imageViewStarsFrame = CGRect(x: frame.origin.x - deltaX,
                                     y: frame.origin.y - deltaY,
                                     width: frame.width + 2 * deltaX,
                                     height: (frame.height + 2 * deltaY) * 0.4)
    
    let imageView = UIImageView()
    imageView.frame = imageViewStarsFrame
    imageView.image = #imageLiteral(resourceName: "Stars")
    self.addSubview(imageView)
  
  }
  
  private func makeGradientLayer() {
    let backgroundColor = UIColor(red: 4.0/255.0, green: 9.0/255.0, blue: 31.0/255.0, alpha: 1).cgColor
    //let leftTopCornerColor = UIColor(red: 41.0/255.0, green: 6.0/255.0, blue: 109.0/255.0, alpha: 1).cgColor
    //let bottomColor = UIColor.red.cgColor//UIColor(red: 60.0/255.0, green: 11.0/255.0, blue: 91.0/255.0, alpha: 1).cgColor
    let leftTopCornerColor = UIColor(red: 41.0/255.0, green: 6.0/255.0, blue: 170.0/255.0, alpha: 1).cgColor
    let bottomColor = UIColor(red: 96.0/255.0, green: 11.0/255.0, blue: 91.0/255.0, alpha: 1).cgColor
    
    // Background layer
    
    let layerBackgroundFrame = CGRect(x: frame.origin.x - deltaX,
                                      y: frame.origin.y - deltaY,
                                      width: frame.width + 2 * deltaX,
                                      height: frame.height + 2 * deltaY)
    
    let layerBackground = CALayer()
    layerBackground.frame = layerBackgroundFrame
    layerBackground.backgroundColor = backgroundColor
    
    layer.addSublayer(layerBackground)
    
    // Gradient layer from left top corner
    
    let gradientLayerFrame = CGRect(x: frame.origin.x - deltaX,
                                    y: frame.origin.y - deltaY,
                                    width: frame.width + 2 * deltaX,
                                    height: (frame.height + 2 * deltaY) / 2)
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = gradientLayerFrame
    gradientLayer.colors = [leftTopCornerColor, backgroundColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.9)
    gradientLayer.opacity = 0.9
    
    layer.addSublayer(gradientLayer)
    
    // Gradient layer from bottom
    
    let gradientLayerBottomFrame = CGRect(x: frame.origin.x - deltaX,
                                          y: (frame.height + deltaY) / 2,
                                          width: frame.width + 2 * deltaX,
                                          height: (frame.height + 2 * deltaY) / 2)
    
    let gradientLayerBottom = CAGradientLayer()
    gradientLayerBottom.frame = gradientLayerBottomFrame
    gradientLayerBottom.colors = [bottomColor, backgroundColor]
    gradientLayerBottom.startPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayerBottom.endPoint = CGPoint(x: 0.5, y: 0.1)
    
    layer.addSublayer(gradientLayerBottom)
  }
  
}
