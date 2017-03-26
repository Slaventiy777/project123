//
//  SearchData.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchData {
  let country: String!  //private?
  let airport: String!
  
  init(_ dictionary: Dictionary<String, String>!) {
    country = dictionary["country"] as String!
    airport = dictionary["airport"] as String!
  }
  
}
