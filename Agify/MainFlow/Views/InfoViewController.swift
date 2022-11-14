//
//  InfoViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 02.11.2022.
//

import Foundation
import SnapKit
import UIKit

final class InfoViewCotroller: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var goBack: (() -> Void)?
    var logout: (() -> Void)?
    let tableView = UITableView()
    let backButton = UIButton.getDefaultButton(title: "Go back")
    let logoutButton = UIButton.getDefaultButton(title: "LogOut", backgroundColor: .red)
    let loader = UIActivityIndicatorView()
    
    private var infoViewModel: InfoViewModelProtocol
    init(infoViewModel: InfoViewModelProtocol) {
        self.infoViewModel = infoViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
        takeInfo()
        bind()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(named: "LightBrown")
        view.backgroundColor = UIColor(named: "LightBrown")
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutPressed), for: .touchUpInside)
    }
    
    private func takeInfo() {
        loader.startAnimating()
        infoViewModel.getIP()
    }
    
    private func bind() {
        infoViewModel.onCompletion = { 
            self.tableView.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    // MARK: - Constraints
    func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { (make) in
            make.trailing.leading.equalToSuperview().inset(50)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(50)
        }
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(logoutButton).inset(75)
        }
        view.addSubview(loader)
        loader.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.bottom.equalTo(backButton).inset(75)
        }
    }
    
    // MARK: - Button Action
    @objc func backButtonPressed() {
        self.goBack?()
    }
    
    @objc func logoutPressed() {
        self.logout?()
    }
    
    // MARK: - TableView Setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRows: Int) -> Int {
        return infoViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell.getDefaultTableCell()
        tableCell.textLabel?.text = infoViewModel.getCellTitle(by: indexPath)
        return tableCell
    }
    
}
