//
//  WeatherResult.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

struct WeatherResult {
    let weather: String
    let maxTemp: Int
    let minTemp: Int
}

extension WeatherResult: Codable {}
