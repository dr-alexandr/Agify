//
//  ToDoViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 15.11.2022.
//

import Foundation
import UIKit

final class ToDoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    var onBack: (() -> Void)?
    
    // MARK: - UIElements
    let tableView = UITableView()
    let backButton = UIButton.getSFButton(sfSymbol: "arrow.left.circle.fill")
    let titleLabel = UILabel.getDefaultLabel(text: "ToDo List", font: 25)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
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
    }
    
    // MARK: - Actions
    @objc func backButtonPressed() {
        self.onBack?()
    }
    
    // MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.getDefaultTableCell()
        cell.textLabel?.text = "Some text"
        return cell
    }
}
