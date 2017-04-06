//
//  AirticketSearchData.swift
//  GTickets
//
//  Created by Slava on 4/6/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchData {
  
  var fromCity: String?
  var toCity: String?
  
  var fromDate: Date?
  var toDate: Date?
  
  var countPeople: People = .one
  var comfortClass: ComfortClass = .economy
  var suitcases: Suitcases = .zero
  
  var isDirectFlight: Bool = false
  var isVisaCheckout: Bool = false
  
  var dateVisaCheckout: Date = Date()
  
  var dayOfStay: DaysOfStay = .thirty
  
  var comments: String = ""
  
  
  
}
