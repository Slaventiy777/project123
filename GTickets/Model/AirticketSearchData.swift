//
//  AirticketSearchData.swift
//  GTickets
//
//  Created by Slava on 4/6/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchData {
  
  let null = NSNull()
  
  /*{
  !"from":"from",
  !"to":"to",
  !"from_date_there":"2017-03-21 22:45:53",
  "from_date_back":null,
  !"class":2,
  !"count_passenger":5,
  !"baggage":1,
  !"direct_flight":1,
  "visa_date":"2017-03-21 22:45:53",
  "visa_days":5,
  "to_date_there":"2017-03-21 22:45:53",
  "to_date_back":"2017-03-21 22:45:53",
  "comment":"comment"
  }*/

  var fromCity: String?
  var toCity: String?
  
  var fromDepartureDate: Date?
  var toDepartureDate: Date?

  var fromReturnDate: Date?
  var toReturnDate: Date?

  var numberOfPassengers: Passenger = .one
  var comfortClass: ComfortClass = .economy
  var baggage: Baggage = .zero
  
  var isDirectFlight: Bool = false
  
  var isVisaCheckout: Bool = false
  var dateVisaCheckout: Date?
  var visaDays: VisaDays = .thirty
  
  var comments: String?
  
//  init(fromCity: String,
//       toCity: String,
//       fromDateDispatch: Date,
//       toDateDispatch: Date,
//       fromDateArrival: Date,
//       toDateArrival: Date,
//       comfortClass: ComfortClass,
//       countPassenger: Passenger,
//       baggage: Baggage,
//       isDirectFlight: Bool,
//       isVisaCheckout: Bool?,
//       dateVisaCheckout: Date?,
//       visaDays: VisaDays?,
//       comments: String?) {
//    self.fromCity = fromCity
//    self.toCity = toCity
//    
//    self.fromDateDispatch = fromDateDispatch
//    self.toDateDispatch = toDateDispatch
//    self.fromDateArrival = fromDateArrival
//    self.toDateArrival = toDateArrival
//    self.comfortClass = comfortClass
//    self.countPassenger = countPassenger
//    self.baggage = baggage
//    self.isDirectFlight = isDirectFlight
//    self.isVisaCheckout = isVisaCheckout
//    self.dateVisaCheckout = dateVisaCheckout
//    self.visaDays = visaDays
//    self.comments = comments
//  }

  func dictionary() -> Dictionary<String, Any> {
    return [
      //"id": UIDevice.current.identifierForVendor!.uuidString,
      "from": fromCity ?? null,
      "to": toCity ?? null,
      "from_date_there": fromDepartureDate ?? null,
      "from_date_back": fromReturnDate ?? null,
      "class": comfortClass.rawValue,
      "count_passenger": numberOfPassengers.rawValue,
      "baggage": baggage.rawValue,
      "direct_flight": isDirectFlight ? 1 : 0,
      "visa_date": dateVisaCheckout ?? null,
      "visa_days": visaDays.rawValue,
      "to_date_there": toDepartureDate ?? null,
      "to_date_back": toReturnDate ?? null,
      "comment": comments ?? null
    ]
  }
  
}
