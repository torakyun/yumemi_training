//
//  CountryModelImpl.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa

final class CountryModelImpl: CountryModel {
    lazy var fetchCountryAction = Action<Void, Country, Error> { [weak self] in
        guard let self = self else { return .empty }
        return self.fetchCountry()
    }
    
    func fetchCountry() -> SignalProducer<Country, Error> {
        SignalProducer<Country, Error> { observer, lifetime in
            guard !lifetime.hasEnded else {
                observer.sendInterrupted()
                return
            }
            DispatchQueue.global().async {
                do {
                    let country: Country = try CountryAPI.fetchCountry()
                    
                    observer.send(value: country)
                    observer.sendCompleted()
                } catch {
                    observer.send(error: error)
                }
            }
        }
    }
}
