//
//  PrefectureSelectorViewModelType.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/06.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

protocol PrefectureSelectorViewModelInputs {
    var viewDidAppear: Signal<Void, Never>.Observer { get }
}

protocol PrefectureSelectorViewModelOutputs {
    var country: Property<Country?> { get }
}

protocol PrefectureSelectorViewModelType {
    var inputs: PrefectureSelectorViewModelInputs { get }
    var outputs: PrefectureSelectorViewModelOutputs { get }
}
