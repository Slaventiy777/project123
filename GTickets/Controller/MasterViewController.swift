//
//  MasterViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
  
  private var currentViewController = UIViewController()
  private var listViewControllers = [ItemLeftMenu: UIViewController]()
  
  private var currentItem: ItemLeftMenu!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewController(for: .airticketSearch)
    currentItem = .airticketSearch
  }
  
  private func updateValueWithCheck(for key: ItemLeftMenu) {
    guard listViewControllers[key] == nil else {
      return
    }
    
    if let viewController = key.viewController {
      listViewControllers.updateValue(viewController, forKey: key)
    }
  }
  
  func setupViewController(for item: ItemLeftMenu) {
    guard currentItem == nil || currentItem != nil && currentItem != item else {
      return
    }
    
    updateView(for: item)
    currentItem = item
  }
  
  private func updateView(for item: ItemLeftMenu) {
    remove(asChildViewController: currentViewController)
    
    updateValueWithCheck(for: item)
    
    if let asChildViewController = listViewControllers[item] {
        add(asChildViewController: asChildViewController)
    }
    
    navigationItem.title = currentViewController.title
    //navigationController?.navigationBar.barTintColor = UIColor.clear
    //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    //navigationController?.navigationBar.shadowImage = UIImage()
    //navigationController?.navigationBar.alpha = 0.5
    
  }
  
  // MARK: - Helper Methods
  
  private func add(asChildViewController viewController: UIViewController) {    
    // Add Child View Controller
    addChildViewController(viewController)
    
    // Add Child View as Subview
    view.addSubview(viewController.view)
    
    // Configure Child View
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // Notify Child View Controller
    viewController.didMove(toParentViewController: self)
    
    currentViewController = viewController
  }
  
  private func remove(asChildViewController viewController: UIViewController) {
    // Notify Child View Controller
    viewController.willMove(toParentViewController: nil)
    
    // Remove Child View From Superview
    viewController.view.removeFromSuperview()
    
    // Notify Child View Controller
    viewController.removeFromParentViewController()
  }
  
}
