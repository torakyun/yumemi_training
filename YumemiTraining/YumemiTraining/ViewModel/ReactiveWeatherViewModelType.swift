//
//  ReactiveWeatherViewModelType.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/25.
//

import Foundation
import ReactiveSwift
import UIKit

protocol ReactiveWeatherViewModelInputs {
    var viewDidAppear: Signal<Void, Never>.Observer { get }
    var reloadButtonDidPress: Signal<Void, Never>.Observer { get }
}

protocol ReactiveWeatherViewModelOutputs {
    var weatherImage: Property<UIImage?> { get }
    var weatherImageColor: Property<UIColor> { get }
    var maxTemp: Property<String?> { get }
    var minTemp: Property<String?> { get }
    var showErrorAlert: Signal<String, Never> { get }
    var isActivityIndicatorViewAnimating: Property<Bool> { get }
}

protocol ReactiveWeatherViewModelType {
    var inputs: ReactiveWeatherViewModelInputs { get }
    var outputs: ReactiveWeatherViewModelOutputs { get }
}
