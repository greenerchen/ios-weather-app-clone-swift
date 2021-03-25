//
//  SectionModel.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import RxDataSources
import RxOpenWeatherMap

enum WeatherTableViewItem {
    case DailyForecastItem(forecast: DailyForecast)
    case WeatherConditionItem(condition: String)
    case WeatherDetailItem(weather: DailyForecast)
}

enum WeatherTableViewSection {
    case DailyForecastSection(items: [WeatherTableViewItem])
    case WeatherConditionSection(items: [WeatherTableViewItem])
    case WeatherDetailSection(items: [WeatherTableViewItem])
}

extension WeatherTableViewSection: SectionModelType {
    typealias Item = WeatherTableViewItem
    
    var items: [WeatherTableViewItem] {
        switch self {
        case .DailyForecastSection(items: let items):
            return items
        case .WeatherConditionSection(items: let items):
            return items
        case .WeatherDetailSection(items: let items):
            return items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}

struct WeatherDataSource {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<WeatherTableViewSection> {
        return .init { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            switch dataSource[indexPath] {
            case .DailyForecastItem(forecast: let forecast):
                let cell: DailyForecastCell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.reuseIdentifier(), for: indexPath) as! DailyForecastCell
                cell.viewModel = DailyForecastCellViewModel(dailyForecast: forecast)
                return cell
            case .WeatherConditionItem(condition: let condition):
                let cell: WeatherConditionCell = tableView.dequeueReusableCell(withIdentifier: WeatherConditionCell.reuseIdentifier(), for: indexPath) as! WeatherConditionCell
                var content = cell.defaultContentConfiguration()
                content.text = condition
                content.textProperties.color = .white
                cell.contentConfiguration = content
                return cell
            case .WeatherDetailItem(weather: let weather):
                let cell: WeatherDetailCell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailCell.reuseIdentifier(), for: indexPath) as! WeatherDetailCell
                cell.viewModel = WeatherDetailCellViewModel(weather: weather, at: indexPath)
                return cell
            }
        }
    }
}
