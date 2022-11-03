//
//  InfoViewController.swift
//  Agify
//
//  Created by Dr.Alexandr on 02.11.2022.
//

import Foundation
import UIKit

final class InfoViewCotroller: UITableViewController {
    
    // MARK: - Properties
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
        takeInfo()
        bind()
    }
    
    // MARK: - Helpers
    private func setupUI() {
        view.backgroundColor = UIColor(named: "LightBrown")
        tableView.tableFooterView = UIView()
    }
    
    private func takeInfo() {
        infoViewModel.getIP()
    }
    
    private func bind() {
        infoViewModel.onCompletion = { 
            self.tableView.reloadData()
        }
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
