//
//  WeatherListTableFooterView.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/2/25.
//

import UIKit
import RxSwift
import RxOpenWeatherMap

class WeatherListTableFooterView: UITableViewHeaderFooterView {

    // MARK: - Initializers
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    class func reuseIdentifier() -> String {
        return "WeatherListTableFooterView"
    }
    
    // MARK: - Properties
    let slashLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let celsiusButton: UIButton = {
        let button = UIButton()
        button.setTitle("°C", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let fahrenheitButton: UIButton = {
        let button = UIButton()
        button.setTitle("°F", for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.lightGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewModel: WeatherListFooterViewModel! {
        didSet {
            configure()
        }
    }
    
    private let disposeBag = DisposeBag()
}

extension WeatherListTableFooterView {
    private func configure() {
        let preferences = PreferenceUtility.shared
        celsiusButton.isSelected = preferences.temperatureUnit == .celsius
        fahrenheitButton.isSelected = preferences.temperatureUnit == .fahrenheit
        
        celsiusButton.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                self.celsiusButton.isSelected = true
                self.fahrenheitButton.isSelected = false
                self.viewModel.temperatureUnitChanged.onNext(.celsius)
            })
            .disposed(by: disposeBag)
        
        fahrenheitButton.rx.tap
            .subscribe(onNext: { [unowned self] (_) in
                self.celsiusButton.isSelected = false
                self.fahrenheitButton.isSelected = true
                self.viewModel.temperatureUnitChanged.onNext(.fahrenheit)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(to: viewModel.searchWeather)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension WeatherListTableFooterView {
    func setupUI() {
        contentView.addSubview(celsiusButton)
        contentView.addSubview(slashLabel)
        contentView.addSubview(fahrenheitButton)
        contentView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            celsiusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            celsiusButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            celsiusButton.trailingAnchor.constraint(equalTo: slashLabel.leadingAnchor),
            celsiusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            celsiusButton.widthAnchor.constraint(equalToConstant: 24),
            
            slashLabel.topAnchor.constraint(equalTo: celsiusButton.topAnchor),
            slashLabel.bottomAnchor.constraint(equalTo: celsiusButton.bottomAnchor),
            slashLabel.trailingAnchor.constraint(equalTo: fahrenheitButton.leadingAnchor),
            slashLabel.widthAnchor.constraint(equalToConstant: 6),
            
            
            fahrenheitButton.topAnchor.constraint(equalTo: celsiusButton.topAnchor),
            fahrenheitButton.bottomAnchor.constraint(equalTo: celsiusButton.bottomAnchor),
            fahrenheitButton.trailingAnchor.constraint(lessThanOrEqualTo: searchButton.leadingAnchor, constant: -100),
            fahrenheitButton.widthAnchor.constraint(equalToConstant: 24),
            
            searchButton.topAnchor.constraint(equalTo: celsiusButton.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: celsiusButton.bottomAnchor),
            searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            searchButton.widthAnchor.constraint(equalToConstant: 30),
            searchButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
