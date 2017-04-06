//
//  RequestManager.swift
//  GTickets
//
//  Created by Slava on 3/30/17.
//  Copyright © 2017 none. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
  public static var rootRef: String {
    return "http://china-air.returnt.ru"
  }
  
  public static func get(urlPath: String, params: Dictionary<String, Any>, callback: @escaping (_ data: Any) -> ()) {
    Alamofire.request("\(rootRef)\(urlPath)").responseJSON { response in
      if let JSON = response.result.value {
        print("URL:\(self.rootRef)\(urlPath)\nJSON: \(JSON)")
        callback(JSON)
      }
    }
  }
  
  public static func post(urlPath: String, params: Dictionary<String, Any>, callback: @escaping (_ data: Any) -> ()) {
    Alamofire.request("\(rootRef)\(urlPath)", method: HTTPMethod.post, parameters: params).responseJSON { response in
      if let JSON = response.result.value {
        print("URL:\(self.rootRef)\(urlPath)\nJSON: \(JSON)")
        callback(JSON)
      }
    }
  }
  
}
