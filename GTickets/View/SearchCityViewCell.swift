//
//  SearchViewCell.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchCityViewCell: UITableViewCell {
  @IBOutlet weak var country: UILabel!
  @IBOutlet weak var airport: UILabel!
  
  public var model: SearchCityData! {
    didSet {
      country.text = model.country
      airport.text = model.airport
    }
  }
  
}
