//
//  WeatherResult.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

struct WeatherResult {
    var weather: String
    var maxTemp: Int
    var minTemp: Int
}

extension WeatherResult: Codable {}
