//
//  ReactiveWeatherViewModelType.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/25.
//

import Foundation
import ReactiveSwift

protocol ReactiveWeatherViewModelInputs {
    var viewDidAppear: Signal<Void, Never>.Observer { get }
    var refresh: Signal<Void, Never>.Observer { get }
}

protocol ReactiveWeatherViewModelOutputs {
    var weatherResult: Signal<WeatherResult, Never> { get }
    var error: Signal<Error, Never> { get }
    var loading: Property<Bool> { get }
}

protocol ReactiveWeatherViewModelType {
    var inputs: ReactiveWeatherViewModelInputs { get }
    var outputs: ReactiveWeatherViewModelOutputs { get }
}
