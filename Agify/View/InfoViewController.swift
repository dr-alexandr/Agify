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
    private var infoTable: [String] = ["IP : ", "City : ", "Region : ",
                                        "Country : ", "Loc : ", "Org : ",
                                        "Postal : ", "Timezone : ", "Readme : "]
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
        infoViewModel.onCompletion = { [weak self] infoModel in
            guard let self = self else { return }
            let array = infoModel.createArr()
            for n in 0..<self.infoTable.count {
                self.infoTable[n] = self.infoTable[n] + array[n]
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TableView Setup
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoTable.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell.getDefaultTableCell()
        tableCell.textLabel?.text = infoTable[indexPath.row]
        return tableCell
    }
    
}
