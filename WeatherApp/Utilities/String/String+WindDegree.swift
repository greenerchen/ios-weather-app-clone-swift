//
//  String+WindDegree.swift
//  WeatherApp
//
//  Created by Greener Chen on 2021/3/11.
//

import Foundation

extension String {
    static func windDirection(fromDegreeDirection degree: Float) -> Self {
        switch degree {
        case 348.75...360, 0...11.25:
            return "N"
        case 11.25...33.75:
            return "NNE"
        case 33.75...56.25:
            return "NE"
        case 56.25...78.75:
            return "ENE"
        case 78.75...101.25:
            return "E"
        case 101.25...123.75:
            return "ESE"
        case 123.75...146.25:
            return "SE"
        case 146.25...168.75:
            return "SSE"
        case 168.75...191.25:
            return "S"
        case 191.25...213.75:
            return "SSW"
        case 213.75...236.25:
            return "SW"
        case 236.25...258.75:
            return "WSW"
        case 258.75...281.25:
            return "W"
        case 281.25...303.75:
            return "WNW"
        case 303.75...326.25:
            return "NW"
        case 326.25...348.75:
            return "NNW"
        default:
            return ""
        }
    }
}
