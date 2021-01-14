//
//  DiffableDataSource.swift
//  Showcase
//
//  Created by So on 2021/01/14.
//

import UIKit
import CoreData

class DiffableDataSource: UITableViewDiffableDataSource<String, NSManagedObjectID> {

  private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
  let frc: NSFetchedResultsController<Employee>

  init(tableView: UITableView) {
    let req: NSFetchRequest<Employee> = Employee.fetchRequest()
    req.sortDescriptors = [NSSortDescriptor(keyPath: \Employee.name, ascending: true)]
    self.frc = NSFetchedResultsController(
      fetchRequest: req,
      managedObjectContext: persistentContainer.viewContext,
      sectionNameKeyPath: #keyPath(Employee.department),
      cacheName: nil
    )
    super.init(tableView: tableView) { [weak frc] tableView, indexPath, objectId -> UITableViewCell? in
      guard let data = frc?.object(at: indexPath) else { return nil }
      let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
      cell.textLabel?.text = "\(data.icon!) \(data.name!)"
      return cell
    }
    frc.delegate = self
    do {
      try frc.performFetch()
    } catch {
      debugPrint(error)
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    frc.sections?[section].name
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    guard editingStyle == .delete else { return }
    persistentContainer.performBackgroundTask { [weak frc] context in
      guard let id = frc?.object(at: indexPath).objectID else { return }
      context.delete(context.object(with: id))
      do {
        try context.save()
      } catch {
        debugPrint(error)
      }
    }
  }
}

extension DiffableDataSource: NSFetchedResultsControllerDelegate {
  func controller(
    _ controller: NSFetchedResultsController<NSFetchRequestResult>,
    didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference
  ) {
    let snapshot = snapshot as NSDiffableDataSourceSnapshot<String, NSManagedObjectID>
    apply(snapshot, animatingDifferences: false)
  }
}
