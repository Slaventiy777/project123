//
//  SearchData.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchCityData {
  let city: String!  //private?
  let airport: String!
  
  init(_ dictionary: Dictionary<String, String>!) {
    city = dictionary["city"] as String!
    airport = dictionary["airport"] as String!
  }
  
}
