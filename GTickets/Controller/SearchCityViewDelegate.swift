//
//  SearchCityViewDelegate.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/31/17.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation

protocol SearchCityViewDelegate {
  //дописывать методы IBAction с вьюхи
  func fromTextFieldDidChange(_ text: String)
  func toTextFieldDidChange(_ text: String)
  
}
