//
//  WeatherModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/09.
//

import Foundation
import ReactiveSwift

protocol WeatherModel: AnyObject {
    func fetchWeather(at area: String, date: Date, completion: @escaping (Result<WeatherResult, Error>) -> Void)
    func fetchWeather(at area: String, date: Date) -> SignalProducer<WeatherResult, Error>
}
