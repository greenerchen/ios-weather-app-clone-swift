//
//  WeatherListTableViewCell.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/25.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {

    class func reuseIdentifier() -> String {
        return "WeatherListTableViewCell"
    }

    var viewModel: WeatherListCellViewModel! {
        didSet {
            configure()
        }
    }
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.numberOfLines = 0
        return label
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 28)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.numberOfLines = 0
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-Thin", size: 50)
        label.textColor = .white
        label.shadowOffset = CGSize(width: 3, height: 3)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    // MARK: Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension WeatherListTableViewCell {
    private func configure() {
        timeLabel.text = viewModel.timeText
        locationLabel.text = viewModel.locationText
        temperatureLabel.text = viewModel.temperatureText
        backgroundColor = viewModel.backgroundColor
    }
}

// MARK: - Setup UI
extension WeatherListTableViewCell {
    private func setupUI() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            timeLabel.heightAnchor.constraint(equalToConstant: 20),

            locationLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            locationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
            
            temperatureLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperatureLabel.bottomAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            temperatureLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
