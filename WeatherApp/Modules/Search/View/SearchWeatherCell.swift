//
//  SearchWeatherCell.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import UIKit

class SearchWeatherCell: UITableViewCell {
    var viewModel: SearchWeatherCellViewModel! {
        didSet {
            configure()
        }
    }
    
    class func reuseIdentifier() -> String {
        return "SearchWeatherCell"
    }
    
    private func configure() {
        var content = defaultContentConfiguration()
        content.text = viewModel.locationText
        contentConfiguration = content
    }
}
