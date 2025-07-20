//
//  BasketProductCell.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 20.07.2025.
//

import UIKit

class BasketProductCell: UITableViewCell {
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .blue
        
        return label
    }()
    

    
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [productNameLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var minusButton: UIButton = {
        let minusButton = UIButton()
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = .systemFont(ofSize: 24)
        minusButton.backgroundColor = .lightGray
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        
        return minusButton
    }()
    
    lazy var plusButton: UIButton = {
        let plusButton = UIButton()
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = .systemFont(ofSize: 24)
        plusButton.backgroundColor = .lightGray
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        return plusButton
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.text = "0"
        countLabel.textAlignment = .center
        countLabel.backgroundColor = .blue
        countLabel.textColor = .white
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return countLabel
    }()
    
    lazy var countView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        return view
    }()
    
    lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleStack, countView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var model: (Product, Int)?
    var basketAction: BasketAction?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind() {
        plusButton.addTarget(self, action: #selector(addToBasket), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(removeFromBasket), for: .touchUpInside)
        countLabel.text = "\(model?.1 ?? 1)"
        productNameLabel.text = model?.0.name ?? ""
        
        if let price = Double(model?.0.price ?? "1") {
            priceLabel.text = "\(Int(price) * (model?.1 ?? 1))".addCurrency()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            countView.heightAnchor.constraint(equalToConstant: 40),
            countView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    @objc func addToBasket() {
        guard let product = self.model?.0 else { return }
        
        DataManager.shared.addToBasket(product: product, count: 1)
        
        basketAction?.reload()
    }
    
    @objc func removeFromBasket() {
        guard let product = self.model?.0 else { return }
        
        DataManager.shared.removeFromBasket(product: product)
        
        basketAction?.reload()
    }
}
