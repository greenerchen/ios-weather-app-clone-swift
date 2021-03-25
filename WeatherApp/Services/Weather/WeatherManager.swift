//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxOpenWeatherMap

fileprivate let cachedWeathersPreferenceKey = "com.greenerchen.weather.cachedWeathers"

class WeatherManager {
    
    static let shared = WeatherManager()
    
    // MARK: - Initializer
    init() {
        do {
            _ = try bindWeatherAtMyLocation()
        } catch {
            print(error)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: self,
                                               queue: nil) { [weak self] (notification) in
            self?.loadFromCache()
        }
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
                                               object: self,
                                               queue: nil) { [weak self] (notification) in
            self?.saveToCache()
        }
        
        preferences.temperatureUnitSubject
            .subscribe(onNext: { [unowned self] (unit) in
                self.apiClient = OpenWeatherMapClient(apiKey: OpenWeatherApiKey,
                                                      temperatureUnit: unit,
                                                      language: Locale.current.languageCode)
                for (index, cachedWeather) in self.weathers.enumerated() {
                    try? self.getWeather(of: cachedWeather.location)
                        .subscribe(onNext: { [unowned self] (weather) in
                            self.weathers[index] = CachedWeather(displayName: cachedWeather.location.localName ?? cachedWeather.location.name, location: cachedWeather.location, weather: weather)
                        })
                        .disposed(by: disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    lazy var locationService: LocationService = {
        LocationService.shared
    }()
    
    lazy var preferences: PreferenceUtility = {
        PreferenceUtility.shared
    }()
    
    lazy var apiClient: OpenWeatherMapClient = {
        OpenWeatherMapClient(apiKey: OpenWeatherApiKey,
                             temperatureUnit: preferences.temperatureUnit,
                             language: Locale.current.languageCode)
    }()
        
    private var weathers: [CachedWeather] = [] {
        didSet {
            weathersSubject.onNext(weathers)
        }
    }
    
    let weathersSubject = BehaviorSubject<[CachedWeather]>(value: [])
}

// MARK: - Manager in-memory weather data
extension WeatherManager {
    func addWeather(_ weather: OneCallResponse, forLocation location: Location) {
        let locationName = location.localName ?? location.name
        weathers.append(CachedWeather(displayName: locationName, location: location, weather: weather))
    }
    
    func deleteWeather(at index: Int) {
        guard index < weathers.count else { return }
        weathers.remove(at: index)
    }
    
    // TODO: reorder weathers
}

// MARK: - Cache weather data
extension WeatherManager {
    func saveToCache() {
        let preferences = UserDefaults.standard
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        archiver.encode(weathers, forKey: cachedWeathersPreferenceKey)
        archiver.finishEncoding()
        preferences.setValue(archiver.encodedData, forKey: cachedWeathersPreferenceKey)
        preferences.synchronize()
    }
    
    func loadFromCache() {
        let preferences = UserDefaults.standard
        guard let data = preferences.value(forKey: cachedWeathersPreferenceKey) else { return }
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data as! Data)
            weathers = unarchiver.decodeArrayOfObjects(ofClass: CachedWeather.self, forKey: cachedWeathersPreferenceKey)!
        } catch {
            print(error)
        }
    }
}

// MARK: - Data Binding
extension WeatherManager {
    private func bindWeatherAtMyLocation() throws {
        var fetchedLocation: Location? = nil
        locationService.location
            .compactMap { $0 }
            .flatMapLatest({ [unowned self] (coordinate) -> Observable<Location> in
                try self.getLocationAt(latitude: coordinate.latitude, longitude: coordinate.longitude)
            })
            .flatMap ({ [unowned self] (location) -> Observable<OneCallResponse> in
                fetchedLocation = location
                return try self.getWeatherAt(latitude: location.latitude, longitude: location.longitude)
            })
            .flatMap ({ (weather) -> Observable<CachedWeather> in
                let locationName = fetchedLocation!.localName ?? fetchedLocation!.name
                return Observable.of(CachedWeather(displayName: locationName, location: fetchedLocation!, weather: weather))
            })
            .subscribe(onNext: { [unowned self] (weather) in
                if self.weathers.isEmpty {
                    self.weathers.append(weather)
                } else {
                    self.weathers[0] = weather
                }
                self.weathersSubject.onNext(self.weathers)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Fetch weathers
extension WeatherManager {
    private func getLocationAt(latitude: Double, longitude: Double) throws -> Observable<Location> {
        return try apiClient
            .reverseGeoCoordinates(latitude: latitude, longitude: longitude)
            .map({ (locations) -> Location in
                locations
                    .filter { $0.localName != nil }
                    .first!
            })
    }
    
    private func getWeatherAt(latitude: Double, longitude: Double) throws -> Observable<OneCallResponse> {
        return try apiClient.oneCall(latitude: latitude, longitude: longitude)
    }
    
    func getWeather(of location: Location) throws -> Observable<OneCallResponse> {
        return try apiClient.oneCall(latitude: location.latitude, longitude: location.longitude)
    }
    
    func getLocations(of query: String) throws -> Observable<[Location]> {
        return try apiClient.geoCoordinates(ofLocationName: query)
    }
}
