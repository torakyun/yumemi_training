//
//  WeatherModelImpl.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import Foundation
import YumemiWeather
import ReactiveSwift

final class WeatherModelImpl: WeatherModel {
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()
    
    private func encodeToJSON<T: Encodable>(parameter: T) throws -> String {
        // エンコーダの作成
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(self.dateFormatter)
        // Dataにエンコード
        let parameterData = try encoder.encode(parameter)
        // JsonStrにデコード
        guard let parameterJsonStr = String(data: parameterData, encoding: .utf8) else {
            throw FetchWeatherError.decodeDataFailed
        }
        return parameterJsonStr
    }
    
    private func decodeJSON<T: Decodable>(to type: T.Type, _ jsonStr: String) throws -> T {
        // Dataにエンコード
        guard let data = jsonStr.data(using: String.Encoding.utf8) else {
            throw FetchWeatherError.encodeDataFailed
        }
        // デコーダの作成
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decodableにデコード
        return try decoder.decode(type, from: data)
    }
    
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<WeatherResult, Error>) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                // weatherParameterを作成
                let weatherParameter = WeatherParameter(area: area, date: date)
                // WeatherPrameterをJsonStrにエンコード
                let weatherParameterJsonStr = try self.encodeToJSON(parameter: weatherParameter)
                // 天気予報をAPIから取得
                let weatherResultJsonStr = try YumemiWeather.syncFetchWeather(weatherParameterJsonStr)
                // WeatherResultにデコード
                let weatherResult =  try self.decodeJSON(to: WeatherResult.self, weatherResultJsonStr)
                
                completion(.success(weatherResult))
            } catch {
                completion(.failure(error))
                
            }
        }
    }
    
    func fetchWeather(at area: String, date: Date) -> SignalProducer<WeatherResult, Error> {
        SignalProducer<WeatherResult, Error> { [weak self] observer, lifetime in
            guard !lifetime.hasEnded else {
                observer.sendInterrupted()
                return
            }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                do {
                    // weatherParameterを作成
                    let weatherParameter = WeatherParameter(area: area, date: date)
                    // WeatherPrameterをJsonStrにエンコード
                    let weatherParameterJsonStr = try self.encodeToJSON(parameter: weatherParameter)
                    // 天気予報をAPIから取得
                    let weatherResultJsonStr = try YumemiWeather.syncFetchWeather(weatherParameterJsonStr)
                    // WeatherResultにデコード
                    let weatherResult =  try self.decodeJSON(to: WeatherResult.self, weatherResultJsonStr)
                    
                    observer.send(value: weatherResult)
                    observer.sendCompleted()
                } catch {
                    observer.send(error: error)
                }
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
