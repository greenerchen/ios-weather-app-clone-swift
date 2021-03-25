//
//  SearchWeatherCellViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import Foundation
import RxOpenWeatherMap

struct SearchWeatherCellViewModel {
    let locationText: String
    let location: Location
    
    init(location: Location) {
        self.location = location
        locationText = "\(location.localName ?? location.name)\(location.state != nil ? " ," + location.state! : ""), \(location.country)"
    }
}
