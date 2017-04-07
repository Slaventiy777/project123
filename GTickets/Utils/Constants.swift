//
//  Constants.swift
//  GTickets
//
//  Created by Slava on 3/30/17.
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
    switch self {
    case .profile:
      return ProfileViewController.storyboardInstance()
    case .order:
      return OrderViewController.storyboardInstance()
    case .airticketSearch:
      return AirticketSearchViewController.storyboardInstance()
    case .buyingTips:
      return BuyingTipsViewController.storyboardInstance()
    case .contacts:
      return ContactsViewController.storyboardInstance()
    case .feedback:
      return FeedbackViewController.storyboardInstance()
    case .share:
      return ShareViewController.storyboardInstance()
    case .settings:
      return SettingsViewController.storyboardInstance()
    default:
      return nil;
    }
  }
  
}

enum Passenger: Int {
  case one = 1, two, three, four, five, six, seven, eight, nine, ten
  
  static var count: Int {
    return 10
  }
}

enum ComfortClass: Int {
  case economy = 1, business, first
  
  var name: String {
    switch self {
    case .economy:
      return "Эконом"
    case .business:
      return "Бизнес"
    case .first:
      return "Первый"
    }
  }
  
  static var count: Int {
    return 3
  }
  
}

enum Baggage: Int {
  case zero, one, two
}

enum VisaDays: Int {
  case thirty = 30
  case sixty = 60
  case ninety = 90
}
