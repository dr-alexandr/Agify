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
    var onBack: (() -> Void)?
    
    // MARK: - UIElements
    let tableView = UITableView()
    let backButton = UIButton.getSFButton(sfSymbol: "arrow.left.circle.fill")
    let addButton = UIButton.getSFButton(sfSymbol: "plus.circle.fill")
    let titleLabel = UILabel.getDefaultLabel(text: String.locString("ToDo List"), font: 25)
    
    let toDoViewModel: ToDoViewModelProtocol
    init(toDoViewModel: ToDoViewModelProtocol) {
        self.toDoViewModel = toDoViewModel
        super.init(nibName: nil, bundle: nil)
        print("Allocation \(self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)
        if compactWidth(self) {
            backButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(50)
                make.leading.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(50)
            }
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(50)
                make.centerY.equalTo(backButton)
            }
            addButton.snp.makeConstraints { (make) in
                make.height.equalTo(50)
                make.width.equalTo(50)
                make.trailing.equalToSuperview().inset(20)
                make.centerY.equalTo(backButton)
            }
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel).inset(75)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        } else {
            backButton.snp.makeConstraints { (make) in
                make.height.width.equalTo(75)
                make.leading.equalToSuperview().inset(50)
                make.top.equalToSuperview().inset(75)
            }
            titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
            titleLabel.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(75)
                make.centerY.equalTo(backButton)
            }
            addButton.snp.makeConstraints { (make) in
                make.height.width.equalTo(75)
                make.trailing.equalToSuperview().inset(50)
                make.centerY.equalTo(backButton)
            }
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel).inset(100)
                make.leading.trailing.equalToSuperview().inset(200)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(named: "LightBrown")
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor(named: "LightBrown")
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func loadData() {
        toDoViewModel.loadData()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @objc func backButtonPressed() {
        self.onBack?()
    }
    
    @objc func addButtonPressed() {
        let alert = toDoViewModel.addNewTask() {
            self.tableView.reloadData()
        }
        present(alert, animated: true, completion: nil) 
    }
    
    // MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoViewModel.getTaskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell")
        cell = toDoViewModel.getCell(indexPath: indexPath)
        if !compactWidth(self) {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 30)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoViewModel.useCheckmark(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            toDoViewModel.deleteCell(indexPath: indexPath) {
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
        }
    }
    
    private func registerTableViewCells() {
        let toDoCell = UINib(nibName: "ToDoCell", bundle: nil)
        self.tableView.register(toDoCell, forCellReuseIdentifier: "ToDoCell")
    }
}
