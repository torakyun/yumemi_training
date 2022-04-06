//
//  Country.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

struct Country {
    let countryName: String
    let regions: [Region]
}

extension Country: Codable {}
