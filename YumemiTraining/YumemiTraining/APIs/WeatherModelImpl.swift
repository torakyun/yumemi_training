//
//  WeatherModelImpl.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import Foundation
import YumemiWeather

protocol WeatherModelDelegate: AnyObject {
    func weatherModel(_ weatherModel: WeatherModel, didFetchWeatherResult result: Result<WeatherResult, Error>)
}

final class WeatherModelImpl: WeatherModel {
    
    weak var delegate: WeatherModelDelegate?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    func fetchWeather(at area: String, date: Date) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                // weatherParameterを作成
                let weatherParameter = WeatherParameter(area: area, date: date)
                // WeatherPrameterをエンコード
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
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
                let weatherResult = try decoder.decode(WeatherResult.self, from: weatherResultData)
                
                self.delegate?.weatherModel(self, didFetchWeatherResult: .success(weatherResult))
            } catch {
                self.delegate?.weatherModel(self, didFetchWeatherResult: .failure(error))
            }
        }
    }
}

extension WeatherModelImpl {
    enum FetchWeatherError: Error {
        case encodeDataFailed
        case decodeDataFailed
    }
}
