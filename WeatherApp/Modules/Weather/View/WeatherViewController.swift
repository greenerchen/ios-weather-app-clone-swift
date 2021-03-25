//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/24.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWeatherView()
        configure()
    }
    
    // MARK: - Initializer
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    convenience init(pageIndex: Int, viewModel: WeatherViewModel) {
        self.init()
        self.pageIndex = pageIndex
        self.viewModel = viewModel
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var pageIndex: Int = 0
    
    var viewModel: WeatherViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var weatherView: WeatherView = {
        let view = WeatherView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: - UI Binding
extension WeatherViewController {
    private func configure() {
        weatherView.viewModel = viewModel
    }
}

// MARK: - setup UI
extension WeatherViewController {
    private func setupWeatherView() {
        view.addSubview(weatherView)
        
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

