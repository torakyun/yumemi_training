//
//  WeatherModelImpl.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import Foundation
import YumemiWeather

final class WeatherModelImpl {
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
}

extension WeatherModelImpl {
    enum FetchWeatherError: Error {
        case encodeDataFailed
        case decodeDataFailed
    }
}

// MARK: - WeatherViewControllerDelegate2
extension WeatherModelImpl: WeatherViewControllerDelegate2 {
    
    func fetchWeather(at area: String, date: Date) throws -> WeatherResult {
        
        // weatherParameterを作成
        let weatherParameter = WeatherParameter(area: area, date: date)
        // WeatherPrameterをエンコード
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        let weatherParameterData = try encoder.encode(weatherParameter)
        
        // 天気予報をAPIから取得
        guard let weatherParameterJsonStr = String(data: weatherParameterData, encoding: .utf8) else {
            throw FetchWeatherError.decodeDataFailed
        }
        let weatherResultJsonStr = try YumemiWeather.syncFetchWeather(weatherParameterJsonStr)
        guard let weatherResultData = weatherResultJsonStr.data(using: String.Encoding.utf8) else {
            throw FetchWeatherError.encodeDataFailed
        }
        
        // WeatherResultをデコード
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(WeatherResult.self, from: weatherResultData)
        
    }
    
    
}
