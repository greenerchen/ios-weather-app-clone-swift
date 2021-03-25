//
//  WeatherConditionCell.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import UIKit

class WeatherConditionCell: UITableViewCell {
    
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

extension WeatherConditionCell {
    private func setupUI() {
        backgroundConfiguration = .clear()
    }
}
