//
//  ListCVCell.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 18.07.2025.
//

import UIKit

class ListCVCell: UICollectionViewCell {
    lazy var favButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .blue
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
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
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, priceLabel, titleLabel, addToBasketButton])
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var listAction: ListAction?
    
    var model: ProductViewModel? {
        didSet {
            bind()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        favButton.tintColor = .white
        model = nil
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        contentView.addSubview(favButton)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            addToBasketButton.heightAnchor.constraint(equalToConstant: 40),
            favButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 5),
            favButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -5),
            favButton.heightAnchor.constraint(equalToConstant: 25),
            favButton.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        favButton.addTarget(self, action: #selector(addToFavorites), for: .touchUpInside)
        addToBasketButton.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
    }
    
    func bind() {
        guard let model = model else { return }
        
        titleLabel.text = model.product.name
        priceLabel.text = model.product.price?.addCurrency()
        imageView.imageFromURL(for: model.product.image ?? "")
        
        favButton.tintColor = model.isFavorite ? .systemYellow : .white
    }
    
    @objc func addToFavorites() {
        favButton.tintColor = (model?.isFavorite ?? false) ? .white : .systemYellow
        
        model?.switchFavorite(completion: { added in
            DispatchQueue.main.async {
                self.favButton.tintColor = added ? .systemYellow : .white
            }
        })
    }
    
    @objc func addToBasket() {
        guard let product = model?.product else { return }

        DataManager.shared.addToBasket(product: product, count: 1)
    }
}


extension Notification.Name {
    static let basketUpdated = Notification.Name("basketUpdated")
}
