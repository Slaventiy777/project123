//
//  LeftMenuCell.swift
//  GTickets
//
//  Created by Slava on 3/16/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {
  
  @IBOutlet weak var itemImageView: UIImageView!
  @IBOutlet weak var itemName: UILabel!
  
  func update(image: UIImage?, name: String?) {
    itemImageView.image = image
    itemName.text = name
  }
  
}
