//
//  PreferenceUtility.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/3/1.
//

import RxSwift
import RxOpenWeatherMap

let OpenWeatherApiKey = "" // PUT YOUR API KEY HERE
let temperataureUnitPreferenceKey = "com.greenerchen.weatherapp.temperatureunit"

class PreferenceUtility {
    
    static let shared = PreferenceUtility()
    
    var preferences: UserDefaults = UserDefaults.standard
    
    let temperatureUnitSubject = PublishSubject<TemperatureUnit>()
    
    var temperatureUnit: TemperatureUnit {
        didSet {
            preferences.setValue(self.temperatureUnit.rawValue, forKey: temperataureUnitPreferenceKey)
            preferences.synchronize()
            temperatureUnitSubject.onNext(self.temperatureUnit)
        }
    }
    
    // MARK: Initializer
    init() {
        if let value = preferences.string(forKey: temperataureUnitPreferenceKey),
           let unit = TemperatureUnit(rawValue: value) {
            temperatureUnit = unit
        } else {
            temperatureUnit = .celsius
        }
        
    }
}
