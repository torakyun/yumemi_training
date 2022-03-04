//
//  WeatherAPI.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import Foundation
import YumemiWeather

enum FetchWeatherError: Error {
    case encodeDataFailed
    case decodeDataFailed
}

enum WeatherAPI {
    
    static func fetchWeather(_ weatherParameter: WeatherParameter) throws -> WeatherResult {
        
        // WeatherPrameterをエンコード
        let weatherParameterData = try JSONEncoder().encode(weatherParameter)
        
        // 天気予報をAPIから取得
        guard let weatherParameterJsonStr = String(data: weatherParameterData, encoding: .utf8) else {
            throw FetchWeatherError.decodeDataFailed
        }
        let weatherResultJsonStr = try YumemiWeather.fetchWeather(weatherParameterJsonStr)
        guard let weatherResultData = weatherResultJsonStr.data(using: String.Encoding.utf8) else {
            throw FetchWeatherError.encodeDataFailed
        }
        
        // WeatherResultをデコード
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(WeatherResult.self, from: weatherResultData)
        
    }
}
