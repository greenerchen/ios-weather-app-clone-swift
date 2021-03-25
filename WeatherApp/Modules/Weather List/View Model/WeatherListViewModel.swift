//
//  WeatherListViewModel.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/25.
//

import RxSwift
import RxOpenWeatherMap

class WeatherListViewModel {
    
    private let disposeBag = DisposeBag()
    
    let selectedRow = PublishSubject<Int>()
    let selectedWeatherLocation = PublishSubject<WeatherListCellViewModel>()
    let addedWeather = PublishSubject<WeatherViewModel>()
    let weathers = PublishSubject<[WeatherViewModel]>()
    let searchWeather = PublishSubject<Void>()
    
    let cellViewModels = BehaviorSubject<[WeatherListCellViewModel]>(value: [])
    
    lazy var weatherManager: WeatherManager = {
        WeatherManager.shared
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.setLocalizedDateFormatFromTemplate("hma")
        return dateFormatter
    }()
    
    init() {
        weatherManager.weathersSubject
            .asObservable()
            .map ({ [weak self] (weathers) -> [WeatherListCellViewModel] in
                guard let `self` = self else { return [] }
                return weathers.map { (cachedWeather) -> WeatherListCellViewModel in
                    self.dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(cachedWeather.weather.timezoneOffset))
                    return WeatherListCellViewModel(timeText: self.dateFormatter.string(from: Date()),
                                                    locationText: cachedWeather.displayName,
                                                    temperatureText: "\(Int(cachedWeather.weather.current.temparature))°",
                                                    backgroundColor: UIColor.color(for: cachedWeather.weather.current))
                }
            })
            .bind(to: cellViewModels)
            .disposed(by: disposeBag)
    }
}
