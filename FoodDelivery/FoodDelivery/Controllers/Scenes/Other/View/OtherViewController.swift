//
//  OtherVC.swift
//  FoodDelivery
//
//  Created by Egemen İnceler on 22.11.2021.
//

import UIKit

class OtherVC: UIViewController, OtherView {
  var presenter: OtherPresenter?
  var rows: [RowStruct] = []
  
  private lazy var tableView: UITableView = {
    let tView = UITableView()
    tView.register(UITableViewCell.self,
                   forCellReuseIdentifier: "cell"
    )
    tView.backgroundColor = .systemBlue
    tView.delegate = self
    tView.dataSource = self
    return tView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    tableView.frame = view.bounds
    view.addSubview(tableView)
    
    presenter?.onViewDidLoad()
  }
  
  func reloadData(with rows: [RowStruct]) {
    DispatchQueue.main.async {
      self.rows = rows
      self.tableView.reloadData()
    }
  }
}

extension OtherVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    rows.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = rows[indexPath.row].name
    return cell
  }
  
  
}

