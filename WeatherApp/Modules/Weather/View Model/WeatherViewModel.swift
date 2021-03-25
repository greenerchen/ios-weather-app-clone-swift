//
//  WeatherViewModel.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/24.
//

import RxSwift
import RxCocoa
import RxOpenWeatherMap

class WeatherViewModel {
    
    private let disposeBag = DisposeBag()
    
    let locationName: Observable<String>
    let weatherConditionText: Observable<String>
    let temperatureText: Observable<String>
    let isTemperatureUnitHidden = BehaviorSubject<Bool>(value: true)
    let temperatureForecastText: Observable<String>
    
    let location: Observable<Location>
    let hourlyForecasts = PublishSubject<[HourlyForecast]>()
    let dailyForecasts = PublishSubject<[DailyForecast]>()
    let todayWeatherCondition = PublishSubject<String>()
    let todayForecast = PublishSubject<DailyForecast>()
    
    let tableViewSections = BehaviorSubject<[WeatherTableViewSection]>(value: [])
    let hourlyForecastsViewModels = BehaviorSubject<[HourlyForecastViewCellModel]>(value: [])
    var backgroundColor: UIColor = .systemBackground
    
    lazy var weatherManager: WeatherManager = {
        WeatherManager.shared
    }()
    
    // MARK: Initializer
    init(location: Location, weather: OneCallResponse) {
        self.location = Observable.of(location)
        self.locationName = Observable.of(location.localName ?? location.name)
        self.weatherConditionText = Observable.of(weather.current.weather.first!.main)
        self.temperatureText = Observable.of("\(Int(roundf(weather.current.temparature)))")
        self.isTemperatureUnitHidden.onNext(false)
        self.temperatureForecastText = Observable.of("H:\(Int(weather.daily[0].temperature.max))°  L:\(Int(weather.daily[0].temperature.min))°")
        
        self.hourlyForecasts.onNext(weather.hourly)
        self.dailyForecasts.onNext(weather.daily)
        let today = weather.daily.first!
        let conditionText = "Today: \(today.weather[0].description). It's currently \(Int(today.temperature.day))°; the high will be \(Int(today.temperature.max))°"
        self.todayWeatherCondition.onNext(conditionText)
        self.todayForecast.onNext(today)
        
        self.tableViewSections.onNext(WeatherViewModel.makeTableViewSections(dailyForecasts: weather.daily, todayWeatherCondition: conditionText, todayForecast: today))
        self.hourlyForecastsViewModels.onNext(WeatherViewModel.makeHourlyForecastsViewModels(current: weather.current, dailyForecasts: weather.daily, hourlyForecasts: weather.hourly))
        self.backgroundColor = UIColor.color(for: weather.current)
    }
    
    private class func makeTableViewSections(dailyForecasts: [DailyForecast], todayWeatherCondition: String, todayForecast: DailyForecast) -> [WeatherTableViewSection] {
        return [
            .DailyForecastSection(items: dailyForecasts.map { WeatherTableViewItem.DailyForecastItem(forecast: $0) }),
            .WeatherConditionSection(items: [WeatherTableViewItem.WeatherConditionItem(condition: todayWeatherCondition)]),
            .WeatherDetailSection(items: Array(repeating: WeatherTableViewItem.WeatherDetailItem(weather: todayForecast), count: 5))
        ]
    }
    
    private class func makeHourlyForecastsViewModels(current: CurrentWeather, dailyForecasts: [DailyForecast], hourlyForecasts: [HourlyForecast]) -> [HourlyForecastViewCellModel] {
        var items: [HourlyForecastViewCellModel] = []
        let sunriseDatetime: TimeInterval = WeatherViewModel.nextSunriseTime(after: current, from: dailyForecasts)
        let sunsetDatetime: TimeInterval = WeatherViewModel.nextSunsetTime(after: current, from: dailyForecasts)
        let now = HourlyForecastViewCellModel(datetime: Date().timeIntervalSince1970,
                                              pop: " ",
                                              iconURL: OpenWeatherMap.url(forIcon: current.weather.first?.icon),
                                              temperature: "\(Int(round(current.temparature)))°")
        items.append(now)
        
        for forecast in hourlyForecasts[0..<24] {
            if let lastItem = items.last,
               sunriseDatetime > lastItem.datetime &&
                sunriseDatetime <= forecast.dt {
                let sunrise = HourlyForecastViewCellModel(datetime: sunriseDatetime,
                                                          pop: " ",
                                                          iconURL: OpenWeatherMap.url(forIcon: current.weather.first?.icon),
                                                          temperature: "Sunrise")
                items.append(sunrise)
            }
            if let lastItem = items.last,
               sunsetDatetime > lastItem.datetime &&
                sunsetDatetime <= forecast.dt {
                let sunset = HourlyForecastViewCellModel(datetime: sunsetDatetime,
                                                         pop: " ",
                                                         iconURL: OpenWeatherMap.url(forIcon: current.weather.first?.icon),
                                                         temperature: "Sunset")
                items.append(sunset)
            }
            items.append(HourlyForecastViewCellModel(hourlyForecast: forecast))
        }
        return items
    }
    
    private class func nextSunriseTime(after current: CurrentWeather, from dailyForecasts: [DailyForecast]) -> TimeInterval {
        if Date().timeIntervalSince1970 > current.sunrise {
            let tomorrow = dailyForecasts[1]
            return tomorrow.sunrise
        } else {
            return current.sunrise
        }
    }
    
    private class func nextSunsetTime(after current: CurrentWeather, from dailyForecasts: [DailyForecast]) -> TimeInterval {
        if Date().timeIntervalSince1970 > current.sunset {
            let tomorrow = dailyForecasts[1]
            return tomorrow.sunset
        } else {
            return current.sunset
        }
    }
}
