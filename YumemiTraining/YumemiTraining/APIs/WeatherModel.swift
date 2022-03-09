//
//  WeatherModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/09.
//

import Foundation

protocol WeatherModel: AnyObject {
    var delegate: WeatherModelDelegate? { get set }
    func fetchWeather(at area: String, date: Date)
}
