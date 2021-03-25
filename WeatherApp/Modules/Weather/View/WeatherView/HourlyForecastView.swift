//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/6.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOpenWeatherMap

fileprivate let cellWidthConstant: CGFloat = 50
fileprivate let cellHeightConstant: CGFloat = 84

class HourlyForecastView: UIView {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: HourlyForecastViewModel! {
        didSet {
            configure()
        }
    }
    
    var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: HourlyForecastView.collectionFlowLayout())
        view.register(HourlyForecastCell.self, forCellWithReuseIdentifier: HourlyForecastCell.reuseIdentifier())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

extension HourlyForecastView {
    private func configure() {
        bindCollectionView()
    }
}

// MARK: - Binding
extension HourlyForecastView {
    private func bindCollectionView() {
        viewModel.hourlyForecasts
            .bind(to: collectionView.rx.items(cellIdentifier: HourlyForecastCell.reuseIdentifier(), cellType: HourlyForecastCell.self)) { indexPath, item, cell in
                cell.viewModel = HourlyForecastViewCellModel(hourlyForecast: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup UI
extension HourlyForecastView {
    private func setupUI() {
        self.backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        let seperatorTop = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.3))
        seperatorTop.backgroundColor = .white
        seperatorTop.translatesAutoresizingMaskIntoConstraints = false
        let seperatorBottom = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.3))
        seperatorBottom.backgroundColor = .white
        seperatorBottom.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(seperatorTop)
        addSubview(collectionView)
        addSubview(seperatorBottom)
        
        NSLayoutConstraint.activate([
            seperatorTop.topAnchor.constraint(equalTo: self.topAnchor),
            seperatorTop.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorTop.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorTop.heightAnchor.constraint(equalToConstant: 0.3),
            
            collectionView.topAnchor.constraint(equalTo: seperatorTop.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: seperatorBottom.topAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 90.4),
            
            seperatorBottom.heightAnchor.constraint(equalToConstant: 0.3),
            seperatorBottom.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorBottom.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorBottom.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        
    }
    
    class func collectionFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        flowLayout.minimumLineSpacing = 5
        return flowLayout
    }
}

