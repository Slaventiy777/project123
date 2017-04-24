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
  
  @IBOutlet weak var cityRightOffset: NSLayoutConstraint!
  @IBOutlet weak var cityLeftOffset: NSLayoutConstraint!
  
  public var model: SearchCityData! {
    didSet {
      city.text = model.city
      airport.text = model.airport
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let inset = getActualSize(23)
    cityLeftOffset.constant = getActualSize(inset)
    cityRightOffset.constant = getActualSize(inset)
    
  }
  
}
