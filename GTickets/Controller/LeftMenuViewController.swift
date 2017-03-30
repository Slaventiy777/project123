//
//  LeftMenuViewController.swift
//  GTickets
//
//  Created by Slava on 3/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
  
  @IBOutlet var leftMenuView: LeftMenuView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    leftMenuView.tableView.register(UINib(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: "CellLeftMenu")
    leftMenuView.tableView.tableFooterView = UIView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
}

// MARK: - UITableViewDelegate
extension LeftMenuViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1.0 / UIScreen.main.scale
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    // There is to add separator line above first cell in section
    let frameHeaderView = CGRect(x: 0,
                                 y: 0,
                                 width: tableView.frame.width,
                                 height: 1 / UIScreen.main.scale)
    let headerView = UIView(frame: frameHeaderView)
    
    let frameTopSeparator = CGRect(x: tableView.separatorInset.left,
                                   y: 0,
                                   width: tableView.frame.size.width - tableView.separatorInset.left - tableView.separatorInset.right,
                                   height: 1 / UIScreen.main.scale)
    let topSeparator = UIView(frame: frameTopSeparator)
    topSeparator.backgroundColor = tableView.separatorColor
    
    headerView.addSubview(topSeparator)
    
    return headerView
  }
  
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
    
    if indexPath.row == ItemLeftMenu.allValues.count - 1 {
      cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, tableView.bounds.width);
    }
    
    return cell
  }
  
}
