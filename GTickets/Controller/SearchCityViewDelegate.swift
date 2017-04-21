//
//  SearchCityViewDelegate.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/31/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

protocol SearchCityViewDelegate: class {
  //дописывать методы IBAction с вьюхи
  func fromTextFieldDidChange(_ text: String)
  func toTextFieldDidChange(_ text: String)

  func swapCityTextFieldsAction()

  func cityChosed(text: String, from: UIViewController)
  
  func chooseDispatchDate()
  func chooseArrivalDate()
  
  func chooseDateVisaCheckout()
  
  func chooseBaggage(_ baggage: Baggage)
  func chooseDirectFlight(_ isSelect: Bool)
  func chooseVisaCheckout(_ isSelect: Bool)
  
  func search()
}
