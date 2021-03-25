//
//  WeatherPageCoordinator.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/24.
//

import RxSwift
import RxCocoa

class WeatherPageCoordinator: ReactiveCoordinator<Void> {
    
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = rootViewController as! WeatherPageViewController
        let viewModel: WeatherPageViewModel = viewController.viewModel
        
        viewModel.showWeatherList
            .flatMap({ [weak self] _ -> Observable<Int> in
                guard let `self` = self else { return .empty() }
                return self.coordinateToWeatherList()
            })
            .bind(to: viewModel.selectedPage)
            .disposed(by: disposeBag)
                
        return Observable.never()
    }
    
    // MARK: - Coordination
    private func coordinateToWeatherList() -> Observable<Int> {
        let weatherListCoordinator = WeatherListCoordinator(rootViewController: rootViewController)
        return coordinate(to: weatherListCoordinator)
    }
}
