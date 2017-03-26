//
//  SearchViewController.swift
//  GTickets
//
//  Created by Marharyta Lytvynenko on 3/26/17.
//  Copyright © 2017 none. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
  private let cellHeight = 60
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  
  //MARK: - UITextFieldDelegate
  
  @IBAction func textFieldDidBeginEditing(_ textField: UITextField) {
    if !(textField.text?.isEmpty)! {
      updateDataSource()
    }
    showTableView(alpha: 1)
  }
  
  @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
    showTableView(alpha: 0)
  }
  
  @IBAction func textFieldDidChange(_ textField: UITextField) {
    updateDataSource()
  }
  
  //MARK: - UIViewController
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Looks for single or multiple taps.
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
    //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
    //tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  //Calls this function when the tap is recognized.
  func dismissKeyboard() {
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    view.endEditing(true)
  }
  
  //MARK: - UITableViewDelegate
  
  private var dataSource: [SearchData] = []
  
  private func makeDataSource(_ array: [Dictionary<String, String>]) {
    var buffer: [SearchData] = []
    array.forEach { item in
      let data = SearchData(item)
      buffer.append(data)
    }
    dataSource = buffer
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return min((textField.text?.characters.count)!, dataSource.count) //dataSource.count
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(cellHeight)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! SearchViewCell
    cell.model = dataSource[indexPath.row]
    return cell
  }
  
  //MARK: - Custom
  
  private func showTableView(alpha: CGFloat) {
    UIView.animate(withDuration: 0.3, animations: {
      self.tableView.alpha = alpha
    })
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
    
    tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(cellHeight * tableView.numberOfRows(inSection: 0)))
  }
  
  
}
