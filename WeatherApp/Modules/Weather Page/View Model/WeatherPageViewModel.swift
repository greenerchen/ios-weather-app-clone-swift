//
//  WeatherPageViewModel.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/24.
//

import RxSwift
import RxOpenWeatherMap
import UIKit

class WeatherPageViewModel {
    private let disposeBag = DisposeBag()
    
    let showWeatherList = PublishSubject<Void>()
    let selectedPage = BehaviorSubject<Int>(value: 0)
    var backgroundColor = BehaviorSubject<UIColor>(value: .systemBackground)
    
    lazy var weatherManager: WeatherManager = {
        WeatherManager.shared
    }()
    
    lazy var weatherViewModels = BehaviorSubject<[WeatherViewModel]>(value: [])
        
    init() {
        weatherManager.weathersSubject
            .asObservable()
            .map ({ (weathers) -> [WeatherViewModel] in
                weathers.map { WeatherViewModel(location: $0.location, weather: $0.weather) }
            })
            .bind(to: weatherViewModels)
            .disposed(by: disposeBag)
        
        weatherViewModels
            .take(2)
            .filter { $0.count > 0 }
            .subscribe(onNext: { [unowned self] (viewModels) in
                self.backgroundColor.onNext(viewModels[0].backgroundColor)
            })
    }
}
