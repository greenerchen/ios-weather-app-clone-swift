//
//  HourlyForecastCell.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/21.
//

import UIKit
import RxSwift

class HourlyForecastCell: UICollectionViewCell {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = " "
        label.shadowOffset = CGSize(width: 0.2, height: 0.2)
        return label
    }()
    
    var popLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 0.1, height: 0.1)
        return label
    }()
    
    var icon: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 0.3, height: 0.3)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var viewModel: HourlyForecastViewCellModel! {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    class func reuseIdentifier() -> String {
        return "\(type(of: Self.self))"
    }
}

extension HourlyForecastCell {
    private func configure() {
        timeLabel.attributedText = NSAttributedString.attributedTimeText(
            viewModel.timeText,
            boldFont: UIFont.boldSystemFont(ofSize: 14),
            formmerFont: UIFont.systemFont(ofSize: 14),
            latterFont: UIFont.systemFont(ofSize: 12)
        )
        popLabel.text = viewModel.pop
        popLabel.rx
            .observe(\.text)
            .map { $0?.isEmpty }
            .subscribe(onNext: { [unowned self] (isEmpty) in
                guard let isEmpty = isEmpty else { return }
                self.popLabel.isHidden = isEmpty
            })
            .disposed(by: DisposeBag())

            
        temperatureLabel.text = viewModel.temperature
        icon.sd_setImage(with: viewModel.iconURL, completed: nil)
    }
}

extension HourlyForecastCell {
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            popLabel,
            icon,
            temperatureLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
