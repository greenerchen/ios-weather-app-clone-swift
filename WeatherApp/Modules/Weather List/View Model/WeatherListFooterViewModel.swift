//
//  WeatherListFooterViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/15.
//

import RxSwift
import RxOpenWeatherMap

struct WeatherListFooterViewModel {
    private let disposeBag = DisposeBag()
    
    let temperatureUnitChanged = PublishSubject<TemperatureUnit>()
    let searchWeather = PublishSubject<Void>()
    
    init() {
        temperatureUnitChanged
            .distinctUntilChanged()
            .subscribe { (unit) in
                PreferenceUtility.shared.temperatureUnit = unit
            }
            .disposed(by: disposeBag)
    }
}
