//
//  AppCoordinator.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/24.
//

import RxSwift

class AppCoordinator: ReactiveCoordinator<Void> {
    
    var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let viewModel = WeatherPageViewModel()
        let viewController = WeatherPageViewController()
        viewController.viewModel = viewModel

        let navigationController = WeatherPageNavigationController(rootViewController: viewController)
        let weatherPageCoordinator = WeatherPageCoordinator(rootViewController: navigationController.viewControllers[0])
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return coordinate(to: weatherPageCoordinator)
    }
}
