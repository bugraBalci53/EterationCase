//
//  FilterCell.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

import UIKit

class FilterTVCell: UITableViewCell {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var safeFilterSection: FilterSection?
    
    var filterSection: FilterSection?
    
    var filterTVCellProtocol: FilterTVCellProtocol?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tableView.register(FilterMultiSelectionCell.self, forCellReuseIdentifier: "FilterMultiSelectionCell")
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        
        safeFilterSection = filterSection
    }
    
    internal func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = filterSection?.multipleSelection ?? false
        
        tableView.separatorStyle = .none
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension FilterTVCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterSection?.filters.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterMultiSelectionCell") as! FilterMultiSelectionCell
        guard let filter = filterSection?.filters[indexPath.row] else { return cell }
        
        cell.bind(filter: filter, multiSelection: filterSection?.multipleSelection ?? false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<(filterSection?.filters.count ?? 0) {
            if i == indexPath.row {
                filterSection?.filters[i].isSelected.toggle()
            } else {
                if !(filterSection?.multipleSelection ?? false) {
                    filterSection?.filters[i].isSelected = false
                }
            }
            
            tableView.reloadData()
        }
        
        filterTVCellProtocol?.selectedFilter(filterSection: filterSection)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
