//
//  WeatherDetailCell.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import UIKit

class WeatherDetailCell: UITableViewCell {
    
    var textLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 0.3, height: 0.3)
        return label
    }()
    
    var valueLabel1: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    var textLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 14)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 0.3, height: 0.3)
        return label
    }()
    
    var valueLabel2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    var viewModel: WeatherDetailCellViewModel! {
        didSet {
            configure()
        }
    }
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    class func reuseIdentifier() -> String {
        return "\(type(of: Self.self))"
    }
}

// Mark: - Data binding
extension WeatherDetailCell {
    private func configure() {
        textLabel1.text = viewModel.text1
        if viewModel.value1 != nil {
            valueLabel1.text = viewModel.value1
        } else {
            valueLabel1.attributedText = viewModel.attributedValue1
        }
        textLabel2.text = viewModel.text2
        if viewModel.value2 != nil {
            valueLabel2.text = viewModel.value2
        } else {
            valueLabel2.attributedText = viewModel.attributedValue2
        }
    }
}

// Mark: - Setup UI
extension WeatherDetailCell {
    private func setupUI() {
        backgroundConfiguration = .clear()
        
        contentView.addSubview(textLabel1)
        contentView.addSubview(textLabel2)
        contentView.addSubview(valueLabel1)
        contentView.addSubview(valueLabel2)
        
        NSLayoutConstraint.activate([
            textLabel1.heightAnchor.constraint(equalToConstant: 16),
            textLabel1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel1.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel1.bottomAnchor.constraint(equalTo: valueLabel1.topAnchor),
            valueLabel1.heightAnchor.constraint(equalToConstant: 30),
            valueLabel1.leadingAnchor.constraint(equalTo: textLabel1.leadingAnchor),
            valueLabel1.trailingAnchor.constraint(equalTo: textLabel1.trailingAnchor),
            valueLabel1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textLabel2.heightAnchor.constraint(equalTo: textLabel1.heightAnchor),
            textLabel2.topAnchor.constraint(equalTo: textLabel1.topAnchor),
            textLabel2.leadingAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabel2.bottomAnchor.constraint(equalTo: valueLabel2.topAnchor),
            valueLabel2.heightAnchor.constraint(equalTo: valueLabel1.heightAnchor),
            valueLabel2.leadingAnchor.constraint(equalTo: textLabel2.leadingAnchor),
            valueLabel2.trailingAnchor.constraint(equalTo: textLabel2.trailingAnchor),
            valueLabel2.bottomAnchor.constraint(equalTo: valueLabel1.bottomAnchor)
        ])
    }
}

