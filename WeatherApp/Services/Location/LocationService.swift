//
//  LocationService.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import Foundation
import CoreLocation
import RxSwift

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    // MARK: - Initializer
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    // MARK: - Properties
    lazy var locationManager: CLLocationManager = {
        CLLocationManager()
    }()
    
    let location: PublishSubject<CLLocationCoordinate2D> = .init()

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location.onNext(location.coordinate)
    }
    
}
