//
//  CurrentWeatherBriefView.swift
//  WeatherApp-MVVMC
//
//  Created by Greener Chen on 2021/3/3.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOpenWeatherMap


class WeatherView: UIView {
    
    // MARK: - Properties
    var topSpace: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 0.5, height: 0.5)
        return label
    }()
    
    var conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 0.3, height: 0.3)
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "--"
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 70)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowColor = .gray
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    lazy var temperatureUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 60)
        label.textColor = .white
        label.text = "°"
        label.shadowColor = .gray
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.isHidden = true
        return label
    }()
    
    var temperatureView: UIView = {
        let view = UIView()
        return view
    }()
    
    var temperatureForecastLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 0.3, height: 0.3)
        return label
    }()
    
    lazy var outerScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var hourlyForecastView: HourlyForecastView = {
        let view = HourlyForecastView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.reuseIdentifier())
        tableView.register(WeatherConditionCell.self, forCellReuseIdentifier: WeatherConditionCell.reuseIdentifier())
        tableView.register(WeatherDetailCell.self, forCellReuseIdentifier: WeatherDetailCell.reuseIdentifier())
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    var topSpaceHeightConstraint: NSLayoutConstraint!
    
    var tableViewTopSpaceHeightConstraint: NSLayoutConstraint!
    
    let minCurrentWeatherHeight: CGFloat = 60
    
    let maxCurrentWeatherHeight: CGFloat = 272
    
    let maskHeight: CGFloat = 212 // maxCurrentWeatherHeight - minCurrentWeatherHeight
    
    var lastContentOffsetY: CGFloat = 0
    
    var viewModel: WeatherViewModel! {
        didSet {
            configure()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - UI Binding
extension WeatherView {
    private func configure() {
        bindBackgroundColor()
        bindCurrentWeatherView()
        bindHourlyForecastView()
        bindTableView()
    }
    
    private func bindBackgroundColor() {
        backgroundColor = viewModel.backgroundColor
        tableView.backgroundColor = viewModel.backgroundColor
    }
    
    private func bindCurrentWeatherView() {
        viewModel.locationName
            .observe(on: MainScheduler.instance)
            .bind(to: locationLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.weatherConditionText
            .observe(on: MainScheduler.instance)
            .bind(to: conditionLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.temperatureText
            .observe(on: MainScheduler.instance)
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.isTemperatureUnitHidden
            .observe(on: MainScheduler.instance)
            .bind(to: temperatureLabel.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.temperatureForecastText
            .observe(on: MainScheduler.instance)
            .bind(to: temperatureForecastLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.tableViewSections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: WeatherDataSource.dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindHourlyForecastView() {
        viewModel.hourlyForecastsViewModels
            .asObservable()
            .bind(to: hourlyForecastView.collectionView.rx.items(cellIdentifier: HourlyForecastCell.reuseIdentifier(), cellType: HourlyForecastCell.self)) { indexPath, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension WeatherView {
    private func setupUI() {
        setupCurrentWeatherView()
        setupOuterScrollView()
    }
    
    private func setupCurrentWeatherView() {
        setupTemperatureView()
        setupLabels()
        
        let stackView = UIStackView(arrangedSubviews: [
            locationLabel,
            conditionLabel,
            temperatureView,
            temperatureForecastLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        self.addSubview(stackView)
        
        topSpaceHeightConstraint = stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: minCurrentWeatherHeight)
        
        NSLayoutConstraint.activate([
            topSpaceHeightConstraint,
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 142)
        ])
    }
    
    private func setupLabels() {
        NSLayoutConstraint.activate([
            locationLabel.heightAnchor.constraint(equalToConstant: 32),
            conditionLabel.heightAnchor.constraint(equalToConstant: 20),
            temperatureView.heightAnchor.constraint(equalToConstant: 70),
            temperatureForecastLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTemperatureView() {
        temperatureView.addSubview(temperatureLabel)
        temperatureView.addSubview(temperatureUnitLabel)
        
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: temperatureView.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: temperatureView.topAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: temperatureView.bottomAnchor),
            temperatureUnitLabel.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
            temperatureUnitLabel.topAnchor.constraint(equalTo: temperatureLabel.topAnchor),
            temperatureUnitLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupOuterScrollView() {
        outerScrollView.delegate = self
        outerScrollView.addSubview(hourlyForecastView)
        outerScrollView.addSubview(tableView)
        self.addSubview(outerScrollView)
        
        tableViewTopSpaceHeightConstraint = hourlyForecastView.topAnchor.constraint(equalTo: outerScrollView.topAnchor, constant: maxCurrentWeatherHeight)
        
        NSLayoutConstraint.activate([
            outerScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            outerScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            outerScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tableViewTopSpaceHeightConstraint,
            hourlyForecastView.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 91),
            
            tableView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: outerScrollView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: outerScrollView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            tableView.heightAnchor.constraint(equalToConstant: self.frame.height - minCurrentWeatherHeight - 91 /* hourlyForecastView */ - 44 /* toolbar */)
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension WeatherView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let bottomSpaceHeight: CGFloat = 60
        let swipeUp = offsetY - lastContentOffsetY > 0
        
        // Bounce
        scrollView.bounces = offsetY <= 0
        
        // Switch focus between scrollview and tableview
        if outerScrollView.isTracking && offsetY >= maskHeight && swipeUp ||
            tableView.contentOffset.y > 0 {
            tableView.isScrollEnabled = true
            tableView.becomeFirstResponder()
            outerScrollView.resignFirstResponder()
        }
        if tableView.isTracking && tableView.contentOffset.y <= 0 && !swipeUp {
            tableView.isScrollEnabled = false
            tableView.resignFirstResponder()
            scrollView.becomeFirstResponder()
        }
        
        if outerScrollView.isTracking {
            // Fading in/out labels of temperaters
            if offsetY > 0 &&
                offsetY <= bottomSpaceHeight {
                temperatureForecastLabel.alpha = 1 - (offsetY / bottomSpaceHeight)
                temperatureView.alpha = 1 - (offsetY / maskHeight)
                
            } else if offsetY > bottomSpaceHeight &&
                        offsetY <= maskHeight {
                temperatureForecastLabel.alpha = 0
                temperatureView.alpha = 1 - (offsetY / maskHeight)
                
            } else if offsetY > maskHeight {
                temperatureForecastLabel.alpha = 0
                temperatureView.alpha = 0
                
            } else {
                temperatureForecastLabel.alpha = 1
                temperatureView.alpha = 1
            }
            
            // Moving top space
            if offsetY > 0 && offsetY <= maskHeight {
                topSpaceHeightConstraint.constant = minCurrentWeatherHeight * (1 - offsetY / maskHeight)
                
            } else if offsetY > maskHeight {
                topSpaceHeightConstraint.constant = 0
//                scrollView.setContentOffset(CGPoint(x: 0, y: maskHeight), animated: false)
                
            } else {
                topSpaceHeightConstraint.constant = minCurrentWeatherHeight
            }
        }
    }
}
