//
//  CachedWeather.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/19.
//

import Foundation
import RxOpenWeatherMap

class CachedWeather: NSObject {
    var displayName: String
    var location: Location
    var weather: OneCallResponse
    
    init(displayName: String, location: Location, weather: OneCallResponse) {
        self.displayName = displayName
        self.location = location
        self.weather = weather
    }
    
    enum CodingKeys: String, CodingKey {
        case displayName
        case location
        case weather
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) has not implemented")
    }
}

extension CachedWeather: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(displayName, forKey: CachedWeather.CodingKeys.displayName.rawValue)
        coder.encode(location, forKey: CachedWeather.CodingKeys.location.rawValue)
        coder.encode(weather, forKey: CachedWeather.CodingKeys.weather.rawValue)
    }
}

extension CachedWeather: NSSecureCoding {
    static var supportsSecureCoding: Bool { true }
}
