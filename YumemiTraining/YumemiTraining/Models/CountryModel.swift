//
//  CountryModel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

import Foundation
import ReactiveSwift

protocol CountryModel {
    var fetchCountryAction: Action<Void, Country, Error> { get }
    func fetchCountry() -> SignalProducer<Country, Error>
}
