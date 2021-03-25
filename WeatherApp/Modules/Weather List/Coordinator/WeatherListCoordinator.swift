//
//  WeatherListCoordinator.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/3/4.
//

import UIKit
import RxSwift

class WeatherListCoordinator: ReactiveCoordinator<Int> {
    
    private let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Int> {
        let viewModel = WeatherListViewModel()
        let viewController = WeatherListViewController()
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .overFullScreen
        rootViewController.present(viewController, animated: true, completion: nil)
        
        viewModel.searchWeather
            .flatMap({ [unowned self] (_) -> Observable<Void> in
                self.coordinateToSearch()
            })
            .subscribe()
            .disposed(by: disposeBag)

        return viewModel.selectedRow
            .take(1)
            .do { [unowned self] (_) in
                self.rootViewController.dismiss(animated: true, completion: nil)
            }
    }
    
    private func coordinateToSearch() -> Observable<Void> {
        let weatherListViewController = rootViewController.presentedViewController as! WeatherListViewController
        let searchWeatherCoordinator = SearchWeatherCoordinator(rootViewController: weatherListViewController)
        return coordinate(to: searchWeatherCoordinator)
    }
}
