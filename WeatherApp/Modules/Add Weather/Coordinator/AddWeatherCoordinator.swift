//
//  AddWeatherCoordinator.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/24.
//

import RxSwift
import RxOpenWeatherMap

enum AddWeatherCoordinationResult {
    case location(Location)
    case cancel
}

class AddWeatherCoordinator: ReactiveCoordinator<AddWeatherCoordinationResult> {
    
    private let rootViewController: UIViewController
    private let location: Location
    private let weather: OneCallResponse
    
    init(rootViewController: UIViewController, location: Location, weather: OneCallResponse) {
        self.rootViewController = rootViewController
        self.location = location
        self.weather = weather
    }
    
    override func start() -> Observable<AddWeatherCoordinationResult> {
        let viewModel = AddWeatherViewModel(location: location, weather: weather)
        let viewController = AddWeatherViewController()
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let location = viewModel.addedLocation.map { CoordinationResult.location($0)}
        let cancel = viewModel.didClose.map { CoordinationResult.cancel }
        
        rootViewController.present(navigationController, animated: true, completion: nil)
        
        return Observable.merge(location, cancel)
            .take(1)
            .do { (_) in
                viewController.dismiss(animated: true, completion: nil)
            }

    }
}
