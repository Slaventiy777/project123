//
//  UIViewController+StoryboardInstance.swift
//  GTickets
//
//  Created by Slava on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

extension UIViewController {
  
  private class func storyboardInstancePrivate<T: UIViewController>() -> T? {
    let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
    return storyboard.instantiateInitialViewController() as? T
  }
  
  class func storyboardInstance() -> Self? {
    return storyboardInstancePrivate()
  }
  
  func addAsChildViewController(_ viewController: UIViewController) {
    // Add Child View Controller
    addChildViewController(viewController)
    
    // Add Child View as Subview
    view.addSubview(viewController.view)
    
    // Configure Child View
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // Notify Child View Controller
    viewController.didMove(toParentViewController: self)
  }
  
  func removeAsChildViewController(_ viewController: UIViewController) {
    // Notify Child View Controller
    viewController.willMove(toParentViewController: nil)
    
    // Remove Child View From Superview
    viewController.view.removeFromSuperview()
    
    // Notify Child View Controller
    viewController.removeFromParentViewController()
  }
  
}
