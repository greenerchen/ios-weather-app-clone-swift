//
//  AddWeatherViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import RxSwift
import RxCocoa
import RxOpenWeatherMap

final class AddWeatherViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Actions
    let addedLocation = PublishSubject<Location>()
    let didClose = PublishSubject<Void>()
    
    let isAddButtonHidden = BehaviorSubject<Bool>(value: false)
    
    let weatherViewModel: WeatherViewModel
    
    var weather: OneCallResponse?
    
    let location: Location
    
    lazy var weatherManager: WeatherManager = {
        WeatherManager.shared
    }()
    
    init(location: Location, weather: OneCallResponse) {
        self.location = location
        self.weather = weather
        self.weatherViewModel = WeatherViewModel(location: location, weather: weather)
    }
    
    func saveLocation() {
        guard let weather = weather else { return }
        weatherManager.addWeather(weather, forLocation: location)
    }
}
