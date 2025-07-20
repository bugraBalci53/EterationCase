//
//  ListViewController.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//

import UIKit

class ListViewController: UIViewController {
    lazy var titleView: UIView = {
        let containerView = UIView()
        let titleLabel = UILabel()
        
        titleLabel.text = "E-Market"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        containerView.backgroundColor = .blue
        
        return containerView
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false

        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var filterBar: UIView = {
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 8
        containerView.alignment = .center
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let filtersLabel = UILabel()
        filtersLabel.text = "Filters:"
        filtersLabel.textColor = .black
        filtersLabel.font = .boldSystemFont(ofSize: 16)
        
        containerView.addArrangedSubview(filtersLabel)
        containerView.addArrangedSubview(filterCollectionView)
        containerView.addArrangedSubview(filterButton)
        
        return containerView
    }()
    
    lazy var filterButton: UIButton = {
        let filterButton = UIButton(type: .system)
        filterButton.setTitle("Select Filter", for: .normal)
        filterButton.backgroundColor = .lightGray
        filterButton.setTitleColor(.white, for: .normal)
        
        return filterButton
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        
        return cv
    }()
    
    lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "No products found."
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
    
    var products: [ProductViewModel] = [] {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()

            emptyStateView.isHidden = !products.isEmpty
            filterBar.isHidden = products.isEmpty
            searchBar.isHidden = products.isEmpty
        }
    }
    
    var filters: [FilterSection] = [] {
        didSet {
            filterCollectionView.delegate = self
            filterCollectionView.dataSource = self
            
            filterCollectionView.reloadData()
        }
    }
    
    
    var filterVC: FilterViewController = {
        let vc = FilterViewController()
        return vc
    }()
    
    let viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(ListCVCell.self, forCellWithReuseIdentifier: "ListCVCell")
        filterCollectionView.register(QuickFilterCVCell.self, forCellWithReuseIdentifier: "QuickFilterCVCell")
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterVC.filterActionProtocol = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "E-Market"
        navigationController?.navigationBar.backgroundColor = .blue
        setupUI()
        bind()
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bind() {
        LoadingManager.shared.show()
        Task {
            let result = await viewModel.fetchProducts()
            
            switch result {
            case .success(let products):
                self.products = products.map({ ProductViewModel.init(product: $0) })
            case .failure(let failure):
                print(failure)
            }
            LoadingManager.shared.hide()
        }
    }
    
    private func setupUI() {
        let stackView = UIStackView(
            arrangedSubviews: [
                searchBar,
                filterBar,
                collectionView
            ]
        )

        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterBar.heightAnchor.constraint(equalToConstant: 50),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 30),

            emptyStateView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor)
        ])

        filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
    }

    
    @objc func showFilters() {
        filterVC.products = viewModel.safeProducts
        
        self.navigationController?.present(filterVC, animated: true)
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ListAction {
    func applyFilter(filters: [FilterSection]) {
        self.filters.removeAll()
        self.products.removeAll()
        
        self.filters = filters
        self.products = Array(viewModel.filteredProducts(filters: filters).map({ ProductViewModel(product: $0) }))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView { return filters.flatMap { $0.filters }.filter { $0.isSelected }.count }
        
        return self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickFilterCVCell", for: indexPath) as! QuickFilterCVCell
            
            let selectedFilters = filters.flatMap { $0.filters }.filter { $0.isSelected }
            cell.titleLabel.text = selectedFilters[indexPath.row].name
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCVCell", for: indexPath) as! ListCVCell
        
        let product = self.products[indexPath.row]
        cell.model = product
        cell.bind()
        cell.listAction = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        
        let vc = DetailViewController()
        vc.product = selectedProduct
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        print(selectedProduct)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView {
            return CGSize(width: 100, height: 40)
        }
        
        let itemWidth = (collectionView.bounds.width - 10) / 2
        return CGSize(width: itemWidth, height: 300)
    }
}

protocol ListAction {
    func applyFilter(filters: [FilterSection]) -> Void
}
