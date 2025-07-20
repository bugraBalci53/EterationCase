//
//  SearchableFilterTVCell.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

import UIKit

class SearchableFilterTVCell: FilterTVCell {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        return searchBar
    }()
    
    var searchFilters = [Filter]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tableView.register(FilterMultiSelectionCell.self, forCellReuseIdentifier: "FilterMultiSelectionCell")
        
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        contentView.addSubview(searchBar)
        contentView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension SearchableFilterTVCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchFilters = filterSection?.filters ?? []
            
            filterSection = safeFilterSection
        } else {
            searchFilters = safeFilterSection?.filters.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            } ?? []
            
            filterSection?.filters = searchFilters
        }
        
        tableView.reloadData()
    }
}
