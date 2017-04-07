//
//  AirticketSearchData.swift
//  GTickets
//
//  Created by Slava on 4/6/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchData {
  
  var fromCity: String
  var toCity: String
  
  var fromDateDispatch: Date
  var toDateDispatch: Date

  var fromDateArrival: Date
  var toDateArrival: Date

  var countPassenger: Passenger
  var comfortClass: ComfortClass
  var baggage: Baggage
  
  var isDirectFlight: Bool? // = false
  var isVisaCheckout: Bool? // = false
  
  var dateVisaCheckout: Date? // = Date()
  
  var visaDays: VisaDays? // = .thirty
  
  var comments: String? // = ""
  
  init(fromCity: String,
       toCity: String,
       fromDateDispatch: Date,
       toDateDispatch: Date,
       fromDateArrival: Date,
       toDateArrival: Date,
       comfortClass: ComfortClass,
       countPassenger: Passenger,
       baggage: Baggage,
       isDirectFlight: Bool,
       isVisaCheckout: Bool?,
       dateVisaCheckout: Date?,
       visaDays: VisaDays?,
       comments: String?) {
    self.fromCity = fromCity
    self.toCity = toCity
    
    self.fromDateDispatch = fromDateDispatch
    self.toDateDispatch = toDateDispatch
    self.fromDateArrival = fromDateArrival
    self.toDateArrival = toDateArrival
    self.comfortClass = comfortClass
    self.countPassenger = countPassenger
    self.baggage = baggage
    self.isDirectFlight = isDirectFlight
    self.isVisaCheckout = isVisaCheckout
    self.dateVisaCheckout = dateVisaCheckout
    self.visaDays = visaDays
    self.comments = comments
  }

  func dictionary() -> Dictionary<String, Any> {
    return [
      //"id": UIDevice.current.identifierForVendor!.uuidString,
      "from" : fromCity,
      "to" : toCity,
      "from_date_there" : fromDateDispatch,
      "from_date_back" : toDateDispatch,
      "class" : comfortClass,
      "count_passenger" : countPassenger,
      "baggage" : baggage,
      "direct_flight" : isDirectFlight ?? "",
      "visa_date" : dateVisaCheckout ?? "",
      "visa_days" : visaDays ?? "",
      "to_date_there" : fromDateArrival,
      "to_date_back" : toDateArrival,
      "comment" : comments ?? ""
    ]
  }
  
}
