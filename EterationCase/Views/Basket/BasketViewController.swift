//
//  BasketViewController.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 20.07.2025.
//

import UIKit

class BasketViewController: UIViewController {
    lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Lets start shopping!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        view.isHidden = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    lazy var checkoutContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        return container
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "5353₺"
        return label
    }()
    
    lazy var checkoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Complete", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    lazy var grandTotal: UIView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let priceView = UIStackView()
        priceView.distribution = .fillEqually
        priceView.axis = .vertical
        
        let priceTitleLabel = UILabel()
        priceTitleLabel.text = "Total:"
        priceTitleLabel.textColor = .blue

        priceView.addArrangedSubview(priceTitleLabel)
        priceView.addArrangedSubview(priceLabel)
        
        container.addArrangedSubview(priceView)
        
        container.addArrangedSubview(checkoutButton)
        
        return container
    }()
    
    let viewModel = BasketViewModel()
    
    var basketProducts: [(Product, Int)] = [] {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.reloadData()
            
            emptyStateView.isHidden = !basketProducts.isEmpty
            checkoutContainer.isHidden = basketProducts.isEmpty
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BasketProductCell.self, forCellReuseIdentifier: "BasketProductCell")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "E-Market"
        navigationController?.navigationBar.backgroundColor = .blue
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        bind()
    }
    
    private func bind() {
        self.basketProducts = viewModel.getBasketProducts()
        priceLabel.text = "\(DataManager.shared.getBasketTotal())".addCurrency()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(checkoutContainer)
        self.view.backgroundColor = .white

        checkoutContainer.addSubview(grandTotal)
        
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: checkoutContainer.topAnchor),
            
            checkoutContainer.heightAnchor.constraint(equalToConstant: 60),
            checkoutContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            grandTotal.leadingAnchor.constraint(equalTo: checkoutContainer.leadingAnchor, constant: 10),
            grandTotal.trailingAnchor.constraint(equalTo: checkoutContainer.trailingAnchor, constant: -10),
            grandTotal.topAnchor.constraint(equalTo: checkoutContainer.topAnchor, constant: 5),
            grandTotal.bottomAnchor.constraint(equalTo: checkoutContainer.bottomAnchor, constant: -5),
            
            emptyStateView.topAnchor.constraint(equalTo: tableView.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
    }
}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource, BasketAction {
    func reload() {
        bind()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketProductCell") as! BasketProductCell
        cell.model = basketProducts[indexPath.row]
        cell.basketAction = self
        cell.bind()
        return cell
    }
}

protocol BasketAction {
    func reload() -> Void
}
