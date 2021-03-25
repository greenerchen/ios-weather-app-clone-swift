//
//  DailyForecastCellViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/6.
//

import RxOpenWeatherMap

struct DailyForecastCellViewModel {
    var day: String
    var iconURL: URL?
    var pop: String
    var maxTemperature: String
    var minTemperature: String
    
    init(dailyForecast: DailyForecast) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        day = dateFormatter.string(from: Date(timeIntervalSince1970: dailyForecast.dt))
        pop = dailyForecast.pop >= 0.3 ? "\(Int(dailyForecast.pop * 100))%" : ""
        maxTemperature = "\(Int(dailyForecast.temperature.max))"
        minTemperature = "\(Int(dailyForecast.temperature.min))"
        iconURL = OpenWeatherMap.url(forIcon: dailyForecast.weather.first?.icon)
        
    }
}
