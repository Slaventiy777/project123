//
//  SearchCityViewController.swift
//  GTickets
//
//  Created by Slava on 3/28/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchCityViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      updateDataSource()

        // Do any additional setup after loading the view.
    }

  fileprivate var dataSource: [SearchCityData] = []
  fileprivate let cellHeight: CGFloat = 60
  
  fileprivate var query: String?
 
  private func makeDataSource(_ array: [Dictionary<String, String>]) {
    var buffer: [SearchCityData] = []
    array.forEach { item in
      let data = SearchCityData(item)
      buffer.append(data)
    }
    dataSource = buffer
  }

  private func updateDataSource() { //место для запроса
    //fill table
    
    let data: [Dictionary<String, String>] = [
      [
        "country": "Киев Украина",
        "airport": "Все фэропорты"
      ],
      [
        "country": "Киш Айленд Иран",
        "airport": "Киш Айленд"
      ],
      [
        "country": "Key West",
        "airport": "International"
      ],
      [
        "country": "Рам-Ки Багамы",
        "airport": "Рам-Ки"
      ],
      [
        "country": "Мангрове Кей Багамы",
        "airport": "Мангров-Ки"
      ],
      [
        "country": "Киев Украина",
        "airport": "Все фэропорты"
      ],
      ]
    
    makeDataSource(data)
    tableView.reloadData()
    tableView.layoutIfNeeded()
    
    //tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(Float(cellHeight) * tableView.numberOfRows(inSection: 0)))
  }
}

//MARK: - UITableViewDelegate

extension SearchCityViewController: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight
  }
  
}

extension SearchCityViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ITEM", for: indexPath) as! SearchCityViewCell
    cell.model = dataSource[indexPath.row]
    return cell
  }
  
}
