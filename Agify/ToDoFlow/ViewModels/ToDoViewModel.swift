//
//  ToDoViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 18.11.2022.
//

import UIKit
import RealmSwift

protocol ToDoViewModelProtocol {
    func loadData()
    func getTaskCount() -> Int
    func addNewTask(compeletion: @escaping (() -> Void)) -> UIAlertController
    func useCheckmark(indexPath: IndexPath)
    func getCell(indexPath: IndexPath) -> UITableViewCell
    func deleteCell(indexPath: IndexPath, completion: () -> Void )
}

final class ToDoViewModel: ToDoViewModelProtocol {
     
    private let realm = try! Realm()
    private var tasks: Results<Task>? {
        get {
            return realm.objects(Task.self).sorted(byKeyPath: "done", ascending: true)
        }
        set {}
    }
    
    func loadData() {
        tasks = realm.objects(Task.self)
    }
    
    func getTaskCount() -> Int {
        return tasks?.count ?? 0
    }

    func addNewTask(compeletion: @escaping (() -> Void)) -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            do {
                try self.realm.write {
                    let newTask = Task()
                    newTask.title = textField.text!
                    newTask.dateCreated = Date()
                    self.realm.add(newTask)
                }
            } catch {
                print("Error writing new Item")
            }
            DispatchQueue.main.async {compeletion()}
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category..."
            textField = alertTextField
        }
        return alert
    }
    
    func useCheckmark(indexPath: IndexPath) {
        guard let cell = tasks?[indexPath.row] else {return}
        do {
            try realm.write {
                cell.done = !cell.done
            }
        } catch {
            print(error)
        }
    }
    
    func getCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.getDefaultTableCell(selection: .default)
        cell.textLabel?.text = tasks?[indexPath.row].title
        cell.accessoryType = tasks?[indexPath.row].done ?? false ? .checkmark : .none
        if tasks?[indexPath.row].done == true {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel?.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
        }
        return cell
    }
    
    func deleteCell(indexPath: IndexPath, completion: () -> Void ) {
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(task)
                }
                completion()
            } catch {
                print(error)
            }
        }
    }
    
    deinit {
        print("Deallocating \(self)")
    }
}
