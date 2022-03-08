//
//  WeatherParameter.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import Foundation

struct WeatherParameter {
    let area: String
    let date: Date
}

extension WeatherParameter: Codable {}
