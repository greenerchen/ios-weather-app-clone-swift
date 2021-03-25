//
//  HourlyForecastViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/6.
//

import RxSwift
import RxOpenWeatherMap

struct HourlyForecastViewModel {
    var hourlyForecasts = PublishSubject<[HourlyForecast]>()
}

struct HourlyForecastViewCellModel {
    var datetime: TimeInterval
    var timeText: String
    var pop: String
    var iconURL: URL?
    var temperature: String
    
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.setLocalizedDateFormatFromTemplate("ha")
        return dateFormatter
    }()
    
    init(datetime: TimeInterval, pop: String, iconURL: URL? = nil, temperature: String) {
        self.timeText = Date().timeIntervalSince1970 - datetime < 1000 ? "Now" : dateFormatter.string(from: Date(timeIntervalSince1970: datetime))
        self.datetime = datetime
        self.pop = pop
        self.iconURL = iconURL
        self.temperature = temperature
    }
    
    init(hourlyForecast: HourlyForecast) {
        timeText = dateFormatter.string(from: Date(timeIntervalSince1970: hourlyForecast.dt))
        datetime = hourlyForecast.dt
        pop = hourlyForecast.pop >= 0.3 ? "\(Int(hourlyForecast.pop * 100))%" : " "
        temperature = "\(Int(round(hourlyForecast.temparature)))°"
        iconURL = OpenWeatherMap.url(forIcon: hourlyForecast.weather.first?.icon)
    }
}
