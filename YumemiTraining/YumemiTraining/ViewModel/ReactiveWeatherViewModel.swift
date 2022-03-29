//
//  ReactiveWeatherViewModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/25.
//

import Foundation
import ReactiveSwift

final class ReactiveWeatherViewModel: NSObject {
    private let model: WeatherModelImpl
    private let load: Action<(String, Date), WeatherResult, Error>
    
    // input
    private let weatherParameterPipe = Signal<(String, Date), Never>.pipe()
    
    // MARK: - NSObject
    
    init(model: WeatherModelImpl) {
        self.model = model
        self.load = Action<(String, Date), WeatherResult, Error> { (area, date) in
            model.fetchWeather(at: area, date: date)
        }
        
        super.init()
        self.setupBind()
    }
    
    // MARK: - Private
    private func setupBind() {
        self.load <~ self.weatherParameterPipe.output
    }
}

// MARK: - ReactiveWeatherViewModelType

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelType {
    var inputs: ReactiveWeatherViewModelInputs { self }
    var outputs: ReactiveWeatherViewModelOutputs { self }
}

// MARK: - ReactiveWeatherViewModelInputs

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelInputs {
    var weatherParameter: Signal<(String, Date), Never>.Observer {
        self.weatherParameterPipe.input
    }
}

// MARK: - ReactiveWeatherViewModelOutputs

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelOutputs {
    var weatherResult: Signal<WeatherResult, Never> {
        self.load.values
    }
    var error: Signal<Error, Never> {
        self.load.errors
    }
    var loading: Property<Bool> {
        self.load.isExecuting
    }
}
