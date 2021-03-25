//
//  WeatherView.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class AddWeatherViewController: UIViewController {
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWeatherView()
        setupNavBar()
        setupNavItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    convenience init(viewModel: AddWeatherViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    
    var viewModel: AddWeatherViewModel! {
        didSet {
            configure()
        }
    }
    
    lazy var addButton: UIBarButtonItem = {
        UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    }()
    
    lazy var weatherView: WeatherView = {
        let view = WeatherView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}

// MARK: - UI Binding
extension AddWeatherViewController {
    private func configure() {
        weatherView.viewModel = viewModel.weatherViewModel
        navigationController?.navigationBar.barTintColor = viewModel.weatherViewModel.backgroundColor
        bindNavItems()
    }
    
    private func bindNavItems() {
        addButton.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                self.viewModel.saveLocation()
                self.viewModel.addedLocation.onNext(self.viewModel.location)
            })
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(to: viewModel.didClose)
            .disposed(by: disposeBag)
    }
}

// MARK: - setup UI
extension AddWeatherViewController {
    private func setupNavBar() {
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.barTintColor = viewModel.weatherViewModel.backgroundColor
    }
    
    private func setupNavItems() {
        guard navigationController != nil else { return }
        
        viewModel.isAddButtonHidden
            .subscribe(onNext: { [unowned self] (isHidden) in
                self.navigationItem.rightBarButtonItem = isHidden ? nil : addButton
            })
            .disposed(by: disposeBag)

        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
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
