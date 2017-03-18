//
//  LeftMenuViewController.swift
//  GTickets
//
//  Created by Slava on 3/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

enum ItemLeftMenu: String {
  case profile = "Мой профиль"
  case order = "Мои заказы"
  case airticketSearch = "Поиск авиабилетов"
  
  static let allValues = [profile, order, airticketSearch]
  
  var index : Int {
    return ItemLeftMenu.allValues.index(of: self)!
  }
  
  var image: UIImage? {
    switch self {
    case .profile:
      return UIImage()
    case .order:
      return UIImage()
    case .airticketSearch:
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
    let mainViewController = sideMenuController!
    let navigationController = mainViewController.rootViewController as! UINavigationController
    let viewController: UIViewController!
    
    if navigationController.viewControllers.first is MasterViewController {
      viewController = navigationController.viewControllers.first
    } else {
      viewController = storyboard!.instantiateViewController(withIdentifier: "masterViewController")
      navigationController.setViewControllers([viewController], animated: false)
    }
    
    (viewController as! MasterViewController).setupViewController(for: ItemLeftMenu.allValues[indexPath.row])
    mainViewController.hideLeftView(animated: true, completionHandler: nil)
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
