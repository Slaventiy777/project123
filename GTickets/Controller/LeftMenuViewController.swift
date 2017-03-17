//
//  LeftMenuViewController.swift
//  GTickets
//
//  Created by Slava on 3/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

enum ItemLeftMenu: String {
  case Profile = "Мой профиль"
  case Order = "Мои заказы"
  
  static let allValues = [Profile, Order]
  
  var index : Int {
    return ItemLeftMenu.allValues.index(of: self)!
  }
  
  var image: UIImage? {
    switch self {
    case .Profile:
      return UIImage()
    case .Order:
      return UIImage()
    }
  }
  
}

class LeftMenuViewController: UIViewController {
  
  @IBOutlet var leftMenuView: LeftMenuView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    leftMenuView.tableView.register(UINib(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: "CellLeftMenu")
  }
  
}

// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let mainViewController = sideMenuController!
//    
//    if indexPath.row == 0 {
//      if mainViewController.isLeftViewAlwaysVisibleForCurrentOrientation {
//        mainViewController.showRightView(animated: true, completionHandler: nil)
//      }
//      else {
//        mainViewController.hideLeftView(animated: true, completionHandler: {
//          mainViewController.showRightView(animated: true, completionHandler: nil)
//        })
//      }
//    }
//    else if indexPath.row == 2 {
//      let navigationController = mainViewController.rootViewController as! NavigationController
//      let viewController: UIViewController!
//      
//      if navigationController.viewControllers.first is ViewController {
//        viewController = self.storyboard!.instantiateViewController(withIdentifier: "OtherViewController")
//      }
//      else {
//        viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
//      }
//      
//      navigationController.setViewControllers([viewController], animated: false)
//      
//      mainViewController.hideLeftView(animated: true, completionHandler: nil)
//    }
//    else {
//      let viewController = UIViewController()
//      viewController.view.backgroundColor = .white
//      viewController.title = "Test \(titlesArray[indexPath.row])"
//      
//      let navigationController = mainViewController.rootViewController as! NavigationController
//      navigationController.pushViewController(viewController, animated: true)
//      
//      mainViewController.hideLeftView(animated: true, completionHandler: nil)
//    }
  }
  
}

// MARK: - UITableViewDataSource
extension LeftMenuViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ItemLeftMenu.allValues.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellLeftMenu",
                                             for: indexPath) as! LeftMenuCell
    
    let item = ItemLeftMenu.allValues[indexPath.row]
    cell.update(image: item.image, name: item.rawValue)
    
    return cell
  }
  
}
