//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import RxOpenWeatherMap

struct WeatherDetailCellViewModel {
    
    let weather: DailyForecast
    var text1: String
    var value1: String?
    var attributedValue1: NSAttributedString?
    var text2: String?
    var value2: String?
    var attributedValue2: NSAttributedString?
    
    enum WeatherDetailRow: Int {
        case sunriseRow = 0
        case chanceOfRainRow
        case windRow
        case precipitationRow
        case cloudinessRow
    }
    
    init(weather: DailyForecast, at indexPath: IndexPath) {
        self.weather = weather
        
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("hma")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        switch WeatherDetailRow(rawValue: indexPath.row) {
        case .sunriseRow:
            text1 = "SUNRISE"
            attributedValue1 = NSAttributedString.attributedTimeText(
                dateFormatter.string(from: Date(timeIntervalSince1970: weather.sunrise)),
                boldFont: UIFont.boldSystemFont(ofSize: 24),
                formmerFont: UIFont.systemFont(ofSize: 24),
                latterFont: UIFont.systemFont(ofSize: 20)
            )
            text2 = "SUNSET"
            attributedValue2 = NSAttributedString.attributedTimeText(
                dateFormatter.string(from: Date(timeIntervalSince1970: weather.sunset)),
                boldFont: UIFont.boldSystemFont(ofSize: 24),
                formmerFont: UIFont.systemFont(ofSize: 24),
                latterFont: UIFont.systemFont(ofSize: 20)
            )
        case .chanceOfRainRow:
            text1 = "CHANCE OF RAIN"
            value1 = "\(Int(weather.pop * 100))%"
            text2 = "HUMIDITY"
            value2 = "\(Int(weather.humidity))%"
        case .windRow:
            text1 = "WIND"
            attributedValue1 = NSAttributedString.attributedText(
                .windDirection(fromDegreeDirection: weather.windDegree) + " \(Int(weather.windSpeed)) m/s",
                font1: UIFont.systemFont(ofSize: 20),
                font2: UIFont.systemFont(ofSize: 24),
                font3: UIFont.systemFont(ofSize: 24)
            )
            text2 = "FEELS LIKE"
            value2 = "\(weather.feelsLike.day)°"
        case .precipitationRow:
            text1 = "PRECIPITATION"
            value1 = "\(Int(weather.rain ?? 0)) cm"
            text2 = "PRESSURE"
            value2 = "\(Int(weather.pressure)) hPa"
        case .cloudinessRow:
            text1 = "CLOUDINESS"
            value1 = "\(Int(weather.clouds))%"
            text2 = "UV Index"
            value2 = "\(Int(weather.uvi))"
        default:
            text1 = ""
            value1 = ""
            text2 = ""
            value2 = ""
        }
    }
    
}
