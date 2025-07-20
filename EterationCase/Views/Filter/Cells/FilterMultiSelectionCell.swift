//
//  FilterMultiSelectionCell.swift
//  EterationCase
//
//  Created by Mehmet Buğra BALCI on 19.07.2025.
//

import UIKit

class FilterMultiSelectionCell: UITableViewCell {
    lazy var containerView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var checkBox: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(filter: Filter, multiSelection: Bool) {
        titleLabel.text = filter.name
        
        if filter.isSelected {
            let buttonImage = multiSelection ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "record.circle")
            checkBox.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = multiSelection ? UIImage(systemName: "square") : UIImage(systemName: "circle")
            checkBox.setImage(buttonImage, for: .normal)
        }
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addArrangedSubview(checkBox)
        containerView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            checkBox.widthAnchor.constraint(equalToConstant: 25),
            checkBox.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
}
