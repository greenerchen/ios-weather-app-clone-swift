//
//  SearchWeatherViewModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import RxSwift
import RxOpenWeatherMap

class SearchWeatherViewModel {
    let selectedLocation = PublishSubject<Location>()
    let addedLocation = PublishSubject<Location>()
    let didClose = PublishSubject<Void>()
    let selectedWeather = PublishSubject<OneCallResponse>()
    let weatherDidAdded = PublishSubject<Void>()
    
    private let client = OpenWeatherMapClient(apiKey: OpenWeatherApiKey,
                                              temperatureUnit: PreferenceUtility.shared.temperatureUnit,
                                              language: Locale.current.languageCode)
    
    func searchLocation(query: String) throws -> Observable<[Location]> {
        return try client.geoCoordinates(ofLocationName: query)
    }
    
    func searchWeather(latitude: Double, longitude: Double) throws -> Observable<OneCallResponse> {
        return try client.oneCall(latitude: latitude, longitude: longitude)
    }
}
