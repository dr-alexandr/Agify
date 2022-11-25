//
//  ToDoViewModel.swift
//  Agify
//
//  Created by Dr.Alexandr on 18.11.2022.
//

import UIKit
import CoreData

protocol ToDoViewModelProtocol {
    func loadData()
    func saveTasks()
    func getTaskCount() -> Int
    func addNewTask(compeletion: @escaping (() -> Void)) -> UIAlertController
    func useCheckmark(indexPath: IndexPath)
    func getCell(indexPath: IndexPath) -> UITableViewCell
    func deleteCell(indexPath: IndexPath, completion: () -> Void )
}

final class ToDoViewModel: ToDoViewModelProtocol {
     
    private var tasks: [Task]? = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func loadData() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let checkmarkSorting = NSSortDescriptor(key:"done", ascending:true)
        request.sortDescriptors = [checkmarkSorting]
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveTasks() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func getTaskCount() -> Int {
        return tasks?.count ?? 0
    }

    func addNewTask(compeletion: @escaping (() -> Void)) -> UIAlertController {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newTask = Task(context: self.context)
            newTask.title = textField.text!
            newTask.done = false
            self.tasks?.append(newTask)
            self.saveTasks()
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
        cell.done = !cell.done
        saveTasks()
        loadData()
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
    
    func deleteCell(indexPath: IndexPath, completion: () -> Void) {
        if let task = tasks?[indexPath.row] {
            tasks?.remove(at: indexPath.row)
            context.delete(task)
            saveTasks()
            completion()
        }
    }
    
    deinit {
        print("Deallocating \(self)")
    }
}
