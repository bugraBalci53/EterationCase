//
//  Product.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

import UIKit

class DetailViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var containerView: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        container.distribution = .equalSpacing
        container.spacing = 10
        
        return container
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var basketContainer: UIView = {
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
    
    lazy var addToBasketButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add To Card", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    lazy var basketView: UIView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let priceView = UIStackView()
        priceView.distribution = .fillEqually
        priceView.axis = .vertical
        
        let priceTitleLabel = UILabel()
        priceTitleLabel.text = "Price:"
        priceTitleLabel.textColor = .blue

        priceView.addArrangedSubview(priceTitleLabel)
        priceView.addArrangedSubview(priceLabel)
        
        container.addArrangedSubview(priceView)
        
        container.addArrangedSubview(addToBasketButton)
        
        return container
    }()
    
    var product: ProductViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = product?.product.name
        navigationController?.navigationBar.backgroundColor = .blue
        navigationController?.navigationBar.tintColor = UIColor.white
        
        let backButtonImage = UIImage(systemName: "chevron.backward")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(customBackAction))
        navigationItem.leftBarButtonItem = backButton
        
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func bind() {
        imageView.imageFromURL(for: product?.product.image ?? "")
        titleLabel.text = (product?.product.brand ?? "") + " " + (product?.product.name ?? "")
        descriptionLabel.text = product?.product.description ?? ""
        priceLabel.text = product?.product.price?.addCurrency()
        
        addToBasketButton.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        view.addSubview(basketContainer)
        self.view.backgroundColor = .white
        
        containerView.addArrangedSubview(imageView)
        containerView.addArrangedSubview(titleLabel)
        containerView.addArrangedSubview(descriptionLabel)
        containerView.addArrangedSubview(UIView())

        basketContainer.addSubview(basketView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: basketContainer.topAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            basketContainer.heightAnchor.constraint(equalToConstant: 60),
            basketContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basketContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basketContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            basketView.leadingAnchor.constraint(equalTo: basketContainer.leadingAnchor, constant: 10),
            basketView.trailingAnchor.constraint(equalTo: basketContainer.trailingAnchor, constant: -10),
            basketView.topAnchor.constraint(equalTo: basketContainer.topAnchor, constant: 5),
            basketView.bottomAnchor.constraint(equalTo: basketContainer.bottomAnchor, constant: -5)
        ])
    }
    
    @objc func customBackAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addToBasket() {
        guard let product = product?.product else { return }

        DataManager.shared.addToBasket(product: product, count: 1)
    }
}
