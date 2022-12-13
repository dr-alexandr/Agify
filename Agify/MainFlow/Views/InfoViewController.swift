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
    
    // MARK: - UIElements
    let tableView = UITableView()
    let backButton = UIButton.getDefaultButton(title: "Go back")
    let logoutButton = UIButton.getDefaultButton(title: "LogOut", backgroundColor: UIColor(red: 156/255, green: 37/255, blue: 77/255, alpha: 1))
    let loader = UIActivityIndicatorView()
    
    // MARK: - Properties
    var goBack: (() -> Void)?
    var logout: (() -> Void)?
    
    private var infoViewModel: InfoViewModelProtocol
    init(infoViewModel: InfoViewModelProtocol) {
        self.infoViewModel = infoViewModel
        super.init(nibName: nil, bundle: nil)
        print("Allocation \(self)")
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
    
    deinit {
        print("Deallocation \(self)")
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
        infoViewModel.onCompletion = { [weak self] in
            guard let self = self else {return}
            self.tableView.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    // MARK: - Constraints
    func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(logoutButton)
        view.addSubview(backButton)
        view.addSubview(loader)
        
        if compactWidth(self) {
            tableView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            logoutButton.snp.makeConstraints { (make) in
                make.trailing.leading.equalToSuperview().inset(50)
                make.height.equalTo(50)
                make.bottom.equalToSuperview().inset(50)
            }
            backButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(50)
                make.leading.trailing.equalToSuperview().inset(50)
                make.bottom.equalTo(logoutButton).inset(75)
            }
            loader.snp.makeConstraints { (make) in
                make.centerX.equalTo(view)
                make.bottom.equalTo(backButton).inset(75)
            }
        } else {
            tableView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().inset(100)
                make.leading.trailing.equalToSuperview().inset(200)
                make.bottom.equalToSuperview()
            }
            logoutButton.layer.cornerRadius = 40
            logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
            logoutButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
                make.width.equalTo(500)
                make.bottom.equalToSuperview().inset(100)
            }
            backButton.layer.cornerRadius = 40
            backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
            backButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(80)
                make.width.equalTo(500)
                make.bottom.equalTo(logoutButton).inset(100)
            }
            loader.transform = CGAffineTransform.init(scaleX: 2, y: 2)
            loader.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(150)
                make.bottom.equalTo(backButton).inset(200)
            }
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
        tableCell.textLabel?.text = String.locString(infoViewModel.getCellTitle(by: indexPath))
        if !compactWidth(self) {
            tableCell.textLabel?.font = UIFont.systemFont(ofSize: 25)
        }
        return tableCell
    }
    
}
