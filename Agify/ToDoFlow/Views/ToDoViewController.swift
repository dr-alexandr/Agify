//
//  ToDoViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 15.11.2022.
//

import Foundation
import UIKit
import RealmSwift

final class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    let realm = try! Realm()
    var tasks: Results<Task>? {
        get {
            return realm.objects(Task.self).sorted(byKeyPath: "done", ascending: true)
        }
        set {}
    }
    var onBack: (() -> Void)?
    
    // MARK: - UIElements
    let tableView = UITableView()
    let backButton = UIButton.getSFButton(sfSymbol: "arrow.left.circle.fill")
    let addButton = UIButton.getSFButton(sfSymbol: "plus.circle.fill")
    let titleLabel = UILabel.getDefaultLabel(text: "ToDo List", font: 25)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        loadData()
    }
    
    deinit {
        print("Deallocating \(self)")
    }
    
    // MARK: - Constraints
    private func setupLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.leading.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(30)
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.centerY.equalTo(backButton)
        }
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(30)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel).inset(75)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.backgroundColor = UIColor(named: "LightBrown")
        self.tableView.tableFooterView = UIView()
        view.backgroundColor = UIColor(named: "LightBrown")
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func loadData() {
            tasks = realm.objects(Task.self)
            tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc func backButtonPressed() {
        self.onBack?()
    }
    
    @objc func addButtonPressed() {
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
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new Category..."
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tasks?[indexPath.row] else {return}
        do {
            try realm.write {
                cell.done = !cell.done
            }
        } catch {
            print(error)
        }
//        tableView.reloadData()
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if let task = tasks?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(task)
                    }
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                } catch {
                    print(error)
                }
            }
        }
    }
}
