//
//  ViewController.swift
//  Showcase
//
//  Created by So on 2021/01/14.
//

import UIKit
import CoreData
import SwiftUI

class ViewController: UIViewController {

  private let tableView = UITableView()
  private lazy var dataSource: UITableViewDataSource = {
    DiffableDataSource(tableView: tableView)
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Employees in our company"
    tableView.dataSource = dataSource
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(onTappedAddButton)
    )
  }

  @objc
  func onTappedAddButton() {
    let vc = UIHostingController(
      rootView: AddEmployeeView()
        .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    )
    navigationController?.present(vc, animated: true, completion: nil)
  }
}
