//
//  InfoViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 02.11.2022.
//

import Foundation
import SnapKit
import UIKit

final class InfoViewCotroller: UITableViewController {
    
    // MARK: - Properties
    var goBack: (() -> Void)?
    let backButton = UIButton.getDefaultButton(title: "Go back")
    
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
        setupUI()
        setupLayout()
        takeInfo()
        bind()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        tableView.tableFooterView = UIView()
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    private func takeInfo() {
        infoViewModel.getIP()
    }
    
    private func bind() {
        infoViewModel.onCompletion = { 
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Constraints
    func setupLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalToSuperview().inset(700)
        }
    }
    
    // MARK: - Button Action
    @objc func backButtonPressed() {
        self.goBack?()
    }
    
    // MARK: - TableView Setup
    override func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRows: Int) -> Int {
        return infoViewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell.getDefaultTableCell()
        tableCell.textLabel?.text = infoViewModel.getCellTitle(by: indexPath)
        return tableCell
    }
    
}
