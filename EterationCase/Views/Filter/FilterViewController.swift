//
//  FilterViewController.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

import UIKit

class FilterViewController: UIViewController {
    lazy var header: UIView = {
        let header = UIView()
        header.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(closeButton)
        header.addSubview(titleLabel)
        
        return header
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        return closeButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Filter"
        
        return titleLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        return tableView
    }()
    
    lazy var applyButton: UIButton = {
        let applyButton = UIButton()
        applyButton.setTitle("Apply", for: .normal)
        applyButton.layer.cornerRadius = 10
        applyButton.backgroundColor = .blue
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        return applyButton
    }()
    
    var sections: [FilterSection] = [] {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var selectedSections = [FilterSection]()
    
    var products = [Product]()
    var filterActionProtocol: ListAction?
    
    let viewModel = FilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FilterTVCell.self, forCellReuseIdentifier: "FilterTVCell")
        tableView.register(SearchableFilterTVCell.self, forCellReuseIdentifier: "SearchableFilterTVCell")
        
        setupUI()
        
        self.sections = viewModel.getFilterSections(products: products, selectedSections: selectedSections)
    }
    
    private func setupUI() {
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(applyButton)
        view.backgroundColor = .white
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(apply), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 50),
            
            closeButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10),
            closeButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: header.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func apply() {
        filterActionProtocol?.applyFilter(filters: selectedSections)
        dismiss(animated: true)
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].type.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections[indexPath.section].searchable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchableFilterTVCell", for: indexPath) as! SearchableFilterTVCell
            cell.filterSection = sections[indexPath.section]
            cell.safeFilterSection = sections[indexPath.section]
            cell.filterTVCellProtocol = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTVCell", for: indexPath) as! FilterTVCell
            cell.filterSection = sections[indexPath.section]
            cell.filterTVCellProtocol = self
            return cell
        }
    }
}

protocol FilterTVCellProtocol {
    func selectedFilter(filterSection: FilterSection?) -> Void
}

extension FilterViewController: FilterTVCellProtocol {
    func selectedFilter(filterSection: FilterSection?) {
        guard let filterSection = filterSection else { return }
        
        selectedSections.removeAll(where: { $0.type == filterSection.type })
        selectedSections.append(filterSection)
    }
}
