//
//  Color.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/20.
//

import UIKit
import RxOpenWeatherMap

// MARK: - Weather
extension UIColor {
    class func color(for current: CurrentWeather) -> UIColor {
        let night = current.dt > current.sunset ? ".night" : ""
        switch current.weather.first!.id {
        case 200..<300:
            return UIColor(named: "thunderstorn\(night)")!
        case 300..<400:
            return UIColor(named: "drizzle\(night)")!
        case 500..<600:
            return UIColor(named: "rain\(night)")!
        case 600..<700:
            return UIColor(named: "snow\(night)")!
        case 700..<800:
            return UIColor(named: "atmosphere\(night)")!
        case 800:
            return UIColor(named: "clear.sky\(night)")!
        case 801..<900:
            return UIColor(named: "clouds\(night)")!
        default:
            return .white
        }
    }
}

// MARK: - Linear interpolation color convertion
// https://stackoverflow.com/a/24687720/657988
extension UIColor {
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        var f = max(0, fraction)
        f = min(f, 1)

        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }

        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
