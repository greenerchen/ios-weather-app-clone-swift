//
//  SearchWeatherCoordinator.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/17.
//

import RxSwift
import RxOpenWeatherMap

class SearchWeatherCoordinator: ReactiveCoordinator<Void> {
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let weatherListViewController = rootViewController as! WeatherListViewController
        let viewController = SearchWeatherViewController()
        let viewModel = SearchWeatherViewModel()
        viewController.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        
        Observable
            .combineLatest(viewModel.selectedLocation, viewModel.selectedWeather)
            .flatMap({ [unowned self] (location, weather) -> Observable<AddWeatherCoordinationResult> in
                self.coordinateToAddWeather(location: location, weather: weather)
            })
            .subscribe(onNext: { (result) in
                guard case .location(_) = result else { return }
                viewController.viewModel.weatherDidAdded.onNext(())
                navigationController.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        weatherListViewController.present(navigationController, animated: true, completion: nil)
        
        return viewModel.didClose
            .take(1)
            .do { [viewController] (_) in
                viewController.dismiss(animated: true, completion: nil)
            }
    }
    
    private func coordinateToAddWeather(location: Location, weather: OneCallResponse) -> Observable<AddWeatherCoordinationResult> {
        let navigationViewController = rootViewController.presentedViewController as! UINavigationController
        let addWeatherCoordinator = AddWeatherCoordinator(rootViewController: navigationViewController.viewControllers[0], location: location, weather: weather)
        return coordinate(to: addWeatherCoordinator)
    }
}
