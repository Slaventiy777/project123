//
//  SearchCityViewController.swift
//  GTickets
//
//  Created by Slava on 3/28/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class AirticketSearchCityResultList: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  fileprivate var dataSource: [SearchCityData] = []
  fileprivate var city: String! = ""
  
  var delegate: SearchCityViewDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    makeDataSource(city: "", callback: {})
    
    tableView.layer.cornerRadius = LAYER_CORNER_RADIUS
    tableView.layer.borderWidth = LAYER_BORDER_WIDTH
    tableView.layer.borderColor = LAYER_BORDER_COLOR

    // Do any additional setup after loading the view.
  }
  
  private func makeDataSource(_ array: [Dictionary<String, String>]) {
    var buffer: [SearchCityData] = []
    array.forEach { item in
      let data = SearchCityData(item)
      buffer.append(data)
    }
    dataSource = buffer
  }
  
  func makeDataSource(city: String, callback: ()->()) { //место для запроса
    //fill table
    self.city = city
    
    let data: [Dictionary<String, String>] = [
      [
        "city": "Киев Украина",
        "airport": "Все фэропорты"
      ],
      [
        "city": "Киш Айленд Иран",
        "airport": "Киш Айленд"
      ],
      [
        "city": "Key West",
        "airport": "International"
      ],
      [
        "city": "Рам-Ки Багамы",
        "airport": "Рам-Ки"
      ],
      [
        "city": "Мангрове Кей Багамы",
        "airport": "Мангров-Ки"
      ],
      [
        "city": "Киев Украина",
        "airport": "Все фэропорты"
      ],
      ]
    
    makeDataSource(data)
    tableView.reloadData()
    tableView.layoutIfNeeded()
    
    callback()
    
  }
}

//MARK: - UITableViewDelegate

extension AirticketSearchCityResultList: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return min(city.characters.count, dataSource.count) //temporary desision (dataSource.count)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ITEM", for: indexPath) as! SearchCityViewCell
    cell.model = dataSource[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let model = dataSource[indexPath.row]
    delegate?.cityChosed(text: model.city, from: self)
  }

}
