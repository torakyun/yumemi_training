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
    var reloadButtonDidPress: Signal<Void, Never>.Observer { get }
}

protocol ReactiveWeatherViewModelOutputs {
    var updateWeather: Signal<WeatherResult, Never> { get }
    var showError: Signal<Error, Never> { get }
    var isActivityIndicatorViewAnimating: Property<Bool> { get }
}

protocol ReactiveWeatherViewModelType {
    var inputs: ReactiveWeatherViewModelInputs { get }
    var outputs: ReactiveWeatherViewModelOutputs { get }
}
