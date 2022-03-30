//
//  ReactiveWeatherViewModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/25.
//

import UIKit
import ReactiveSwift

final class ReactiveWeatherViewModel: NSObject {
    private let model: WeatherModelImpl
    private let load: Action<(String, Date), WeatherResult, Error>
    
    // input
    private let viewDidAppearPipe = Signal<Void, Never>.pipe()
    private let refreshPipe = Signal<Void, Never>.pipe()
    
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
        // リロードを行うシグナル
        let willReloadSignal = Signal.merge(
            NotificationCenter.default.reactive
                .notifications(forName: UIApplication.willEnterForegroundNotification, object: nil)
                .map { _ in },
            self.viewDidAppearPipe.output,
            self.refreshPipe.output
        )
        self.load <~ willReloadSignal.map(value: ("tokyo", Date()))
    }
}

// MARK: - ReactiveWeatherViewModelType

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelType {
    var inputs: ReactiveWeatherViewModelInputs { self }
    var outputs: ReactiveWeatherViewModelOutputs { self }
}

// MARK: - ReactiveWeatherViewModelInputs

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelInputs {
    var viewDidAppear: Signal<Void, Never>.Observer {
        self.viewDidAppearPipe.input
    }
    var refresh: Signal<Void, Never>.Observer {
        self.refreshPipe.input
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
