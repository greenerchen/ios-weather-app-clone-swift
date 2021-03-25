//
//  WeatherPageNavigationController.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/25.
//

import UIKit

class WeatherPageNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavigationBar()
        setupToolbar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        isNavigationBarHidden = true
    }
    
    private func setupToolbar() {
        isToolbarHidden = false
        toolbar.isTranslucent = true
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.barTintColor = .clear
    }

}
