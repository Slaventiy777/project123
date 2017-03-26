//
//  MasterViewController.swift
//  GTickets
//
//  Created by Slava on 3/18/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
  
  @IBOutlet weak var masterView: MasterView!
  
  private var masterSubviewController: UIViewController!  
  private var currentViewController = UIViewController()
  private var listViewControllers = [ItemLeftMenu: UIViewController]()
  
  private var currentItem: ItemLeftMenu!
  
  // MARK: -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    masterView.updateView()
    addParallax(to: masterView)
    
    setupViewController(for: .airticketSearch)
    currentItem = .airticketSearch
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "masterSubviewController" {
      masterSubviewController = segue.destination
    }
  }
  
  // MARK: -
  
  private func updateValueWithCheck(for key: ItemLeftMenu) {
    guard listViewControllers[key] == nil else {
      return
    }
    
    if let viewController = key.viewController {
      listViewControllers.updateValue(viewController, forKey: key)
    }
  }
  
  func setupViewController(for item: ItemLeftMenu) {
    guard currentItem == nil || (currentItem != nil && currentItem != item) else {
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
    navigationController?.navigationBar.tintColor = UIColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    navigationController?.navigationBar.barTintColor = UIColor.clear
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    //navigationController?.navigationBar.shadowImage = UIImage()
    //navigationController?.navigationBar.alpha = 0.5
    
    navigationController?.navigationBar.layer.masksToBounds = false
    navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
    navigationController?.navigationBar.layer.shadowOpacity = 0.99
    navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 5.0)
    navigationController?.navigationBar.layer.shadowRadius = 5
    /*let shadowView = UIView(frame: (navigationController?.navigationBar.frame)!)
    shadowView.backgroundColor = UIColor.clear
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOpacity = 0.8
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    shadowView.layer.shadowRadius = 4
    view.addSubview(shadowView)*/
  }
  
  // MARK: - Helper Methods
  
  private func add(asChildViewController viewController: UIViewController) {    
    // Add Child View Controller
    masterSubviewController.addChildViewController(viewController)
    
    // Add Child View as Subview
    masterSubviewController.view.addSubview(viewController.view)
    
    // Configure Child View
    viewController.view.frame = masterSubviewController.view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    // Notify Child View Controller
    viewController.didMove(toParentViewController: masterSubviewController)
    
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
  
  private func addParallax(to view: UIView) {
    let min = CGFloat(-100)
    let max = CGFloat(100)
    
    let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x",
                                              type: .tiltAlongHorizontalAxis) // or "center.x"
    xMotion.minimumRelativeValue = min
    xMotion.maximumRelativeValue = max
    
    let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y",
                                              type: .tiltAlongVerticalAxis) // or "center.y"
    yMotion.minimumRelativeValue = min
    yMotion.maximumRelativeValue = max
    
    let motionEffectGroup = UIMotionEffectGroup()
    motionEffectGroup.motionEffects = [xMotion,yMotion]
    
    view.addMotionEffect(motionEffectGroup)
  }
  
}
