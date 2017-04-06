//
//  SearchCityViewDelegate.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/31/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

protocol SearchCityViewDelegate {
  //дописывать методы IBAction с вьюхи
  func fromTextFieldDidChange()
  func toTextFieldDidChange()

  func swapCityTextFieldsAction()

  func cityChosed(text: String, from: UIViewController)
  
  func chooseDispatchDate()
  
  func chooseArrivalDate()
  
  func search()
}
