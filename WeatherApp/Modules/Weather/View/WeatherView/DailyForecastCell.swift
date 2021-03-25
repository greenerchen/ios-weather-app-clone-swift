//
//  DailyForecastCell.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/5.
//

import UIKit
import SDWebImage

class DailyForecastCell: UITableViewCell {
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var popLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()
    
    var maxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    var minTemperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    var viewModel: DailyForecastCellViewModel! {
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
extension DailyForecastCell {
    private func configure() {
        dayLabel.text = viewModel.day
        icon.sd_setImage(with: viewModel.iconURL, completed: nil)
        popLabel.text = viewModel.pop
        maxTemperatureLabel.text = viewModel.maxTemperature
        minTemperatureLabel.text = viewModel.minTemperature
    }
}

// Mark: - Setup UI
extension DailyForecastCell {
    private func setupUI() {
        backgroundConfiguration = .clear()
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(icon)
        contentView.addSubview(popLabel)
        contentView.addSubview(maxTemperatureLabel)
        contentView.addSubview(minTemperatureLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 130),
            dayLabel.heightAnchor.constraint(equalToConstant: 28),
            dayLabel.trailingAnchor.constraint(equalTo: icon.leadingAnchor),
            
            icon.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            icon.trailingAnchor.constraint(equalTo: popLabel.leadingAnchor),
            
            popLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            popLabel.widthAnchor.constraint(equalToConstant: 40),
            popLabel.trailingAnchor.constraint(equalTo: maxTemperatureLabel.leadingAnchor, constant: -10),
            
            maxTemperatureLabel.centerYAnchor.constraint(equalTo: popLabel.centerYAnchor),
            maxTemperatureLabel.widthAnchor.constraint(equalToConstant: 24),
            maxTemperatureLabel.heightAnchor.constraint(equalTo: maxTemperatureLabel.widthAnchor),
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -20),
            
            minTemperatureLabel.centerYAnchor.constraint(equalTo: maxTemperatureLabel.centerYAnchor),
            minTemperatureLabel.widthAnchor.constraint(equalToConstant: 24),
            minTemperatureLabel.heightAnchor.constraint(equalTo: minTemperatureLabel.widthAnchor),
            minTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
