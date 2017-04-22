//
//  DateExtention.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 4/22/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

extension Date {
  func string() -> String {
    let date = self
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d.MM"
    return dateFormatter.string(from: date)
  }
}
