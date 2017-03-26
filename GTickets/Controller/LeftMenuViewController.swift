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
  case buyingTips = "Советы по покупке билетов"
  case contacts = "Контакты"
  case feedback = "Оставить отзыв"
  case share = "Поделится с друзьями"
  case settings = "Настройки"
  case exit = "Выйти"
  
  static let allValues = [profile,
                          order,
                          airticketSearch,
                          buyingTips,
                          contacts,
                          feedback,
                          share,
                          settings,
                          exit]
  
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
    case .buyingTips:
      return UIImage()
    case .contacts:
      return UIImage()
    case .feedback:
      return UIImage()
    case .share:
      return UIImage()
    case .settings:
      return UIImage()
    case .exit:
      return UIImage()
    }
  }
  
  var viewController: UIViewController? {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    switch self {
    case .profile:
      return storyboard.instantiateViewController(withIdentifier: "profileViewController") as! ProfileViewController
    case .order:
      return storyboard.instantiateViewController(withIdentifier: "orderViewController") as! OrderViewController
    case .airticketSearch:
      return AirticketSearchViewController.storyboardInstance() //storyboard.instantiateViewController(withIdentifier: "airticketSearchViewController") as! AirticketSearchViewController
    case .buyingTips:
      return storyboard.instantiateViewController(withIdentifier: "buyingTipsViewController") as! BuyingTipsViewController
    case .contacts:
      return storyboard.instantiateViewController(withIdentifier: "contactsViewController") as! ContactsViewController
    case .feedback:
      return storyboard.instantiateViewController(withIdentifier: "feedbackViewController") as! FeedbackViewController
    case .share:
      return storyboard.instantiateViewController(withIdentifier: "shareViewController") as! ShareViewController
    case .settings:
      return storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
    default:
      return nil;
    }
  }

}

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
