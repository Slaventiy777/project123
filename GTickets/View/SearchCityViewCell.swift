//
//  SearchViewCell.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchCityViewCell: UITableViewCell {
  @IBOutlet weak var city: UILabel!
  @IBOutlet weak var airport: UILabel!
  
  public var model: SearchCityData! {
    didSet {
      city.text = model.city
      airport.text = model.airport
    }
  }
  
}
