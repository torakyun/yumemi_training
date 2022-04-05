//
//  ReactiveWeatherViewModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/25.
//

import UIKit
import ReactiveSwift
import YumemiWeather

final class ReactiveWeatherViewModel: NSObject {
    private let model: WeatherModelImpl
    private let load: Action<(String, Date), WeatherResult, Error>
    
    // input
    private let viewDidAppearPipe = Signal<Void, Never>.pipe()
    private let reloadButtonDidPressPipe = Signal<Void, Never>.pipe()
    // output
    private let _image = MutableProperty<UIImage?>(nil)
    private let _color = MutableProperty<UIColor>(.tintColor)
    private let _maxTemp = MutableProperty<String?>(nil)
    private let _minTemp = MutableProperty<String?>(nil)
    
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
            self.reloadButtonDidPressPipe.output
        )
        self.load <~ willReloadSignal.map(value: ("tokyo", Date()))
        
        self.reactive.changeWeatherImageResource <~ self.load.values.map { $0.weather }
        self._maxTemp <~ self.load.values.map { String($0.maxTemp) }
        self._minTemp <~ self.load.values.map { String($0.minTemp) }
    }
    
    fileprivate func changeWeatherImageResource(_ weather: String) {
        let image: (UIImage?, UIColor?)
        switch weather {
        case "sunny":
            image = (UIImage(named: "sunny"), .red)
        case "cloudy":
            image = (UIImage(named: "cloudy"), .gray)
        case "rainy":
            image = (UIImage(named: "rainy"), .blue)
        default:
            image = (nil, nil)
        }
        
        self._image.value = image.0
        if let color = image.1 {
            self._color.value = color
        }
    }
    
    private func makeErrorMessage(_ error: Error) -> String {
        switch error {
        case WeatherModelImpl.FetchWeatherError.decodeDataFailed:
            return "JSONエンコードに失敗"
        case WeatherModelImpl.FetchWeatherError.decodeDataFailed:
            return "JSONデコードに失敗"
        case YumemiWeatherError.unknownError:
            return "天気情報の取得に失敗"
        default:
            return "エラー発生"
        }
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
    var reloadButtonDidPress: Signal<Void, Never>.Observer {
        self.reloadButtonDidPressPipe.input
    }
}

// MARK: - ReactiveWeatherViewModelOutputs

extension ReactiveWeatherViewModel: ReactiveWeatherViewModelOutputs {
    var image: Property<UIImage?> {
        Property<UIImage?>(self._image)
    }
    var color: Property<UIColor> {
        Property<UIColor>(self._color)
    }
    var maxTemp: Property<String?> {
        Property<String?>(self._maxTemp)
    }
    var minTemp: Property<String?> {
        Property<String?>(self._minTemp)
    }
    var showErrorAlert: Signal<String, Never> {
        self.load.errors.map { self.makeErrorMessage($0) }
    }
    var isActivityIndicatorViewAnimating: Property<Bool> {
        self.load.isExecuting
    }
}

// MARK: - Reactive

private extension Reactive where Base == ReactiveWeatherViewModel {
    var changeWeatherImageResource: BindingTarget<String> {
        self.makeBindingTarget { base, weather in
            base.changeWeatherImageResource(weather)
        }
    }
}
