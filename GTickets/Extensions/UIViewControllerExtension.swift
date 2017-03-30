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
  
}
