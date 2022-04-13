//
//  PrefectureSelectorViewModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/06.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

final class PrefectureSelectorViewModel {
    private let model: CountryModelImpl
    private let load: Action<Void, Country, Error>
    
    // input
    private let viewDidAppearPipe = Signal<Void, Never>.pipe()
    
    // output
    private let _country = MutableProperty<Country?>(nil)
    
    init(model: CountryModelImpl) {
        self.model = model
        self.load = Action<Void, Country, Error> {
            model.fetchCountry()
        }
        
        self.setupBind()
    }
    
    // MARK: - Private
    private func setupBind(){
        self.load <~ self.viewDidAppearPipe.output
        self._country <~ self.load.values
    }
}

// MARK: - PrefectureSelectorViewModelType

extension PrefectureSelectorViewModel: PrefectureSelectorViewModelType {
    var inputs: PrefectureSelectorViewModelInputs { self }
    var outputs: PrefectureSelectorViewModelOutputs { self }
}

// MARK: - PrefectureSelectorViewModelInputs

extension PrefectureSelectorViewModel: PrefectureSelectorViewModelInputs {
    var viewDidAppear: Signal<Void, Never>.Observer {
        self.viewDidAppearPipe.input
    }
}

// MARK: - PrefectureSelectorViewModelOutputs

extension PrefectureSelectorViewModel: PrefectureSelectorViewModelOutputs {
    var country: Property<Country?> {
        Property<Country?>(self._country)
    }
}
