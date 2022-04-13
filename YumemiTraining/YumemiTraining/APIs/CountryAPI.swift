//
//  CountryAPI.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

import Foundation

enum CountryAPI {
    static func fetchCountry<T: Decodable>() throws -> T {
        
        var hokkaidoRegion = Dictionary<String, Any>()
        hokkaidoRegion["regionName"] = "hokkaido"
        var hokkaidoPrefectures = Array<Any>()
        hokkaidoPrefectures.append(contentsOf: ["hokkaido"])
        hokkaidoRegion["prefectures"] = hokkaidoPrefectures
        
        var tohokuRegion = Dictionary<String, Any>()
        tohokuRegion["regionName"] = "tohoku"
        var tohokuPrefectures = Array<Any>()
        tohokuPrefectures.append(contentsOf: ["aomori", "iwate", "miyagi", "akita", "yamagata", "hukusima"])
        tohokuRegion["prefectures"] = tohokuPrefectures
        
        var kantoRegion = Dictionary<String, Any>()
        kantoRegion["regionName"] = "kanto"
        var kantoPrefectures = Array<Any>()
        kantoPrefectures.append(contentsOf: ["tokyo", "ibaraki", "tochigi", "gunma", "saitama", "chiba", "kanagawa"])
        kantoRegion["prefectures"] = kantoPrefectures
        
        var chubuRegion = Dictionary<String, Any>()
        chubuRegion["regionName"] = "chubu"
        var chubuPrefectures = Array<Any>()
        chubuPrefectures.append(contentsOf: ["nigata", "toyama", "ishikawa", "hukui", "yamanashi", "nagano", "gihu", "shizuoka", "aichi"])
        chubuRegion["prefectures"] = chubuPrefectures
        
        var kinkiRegion = Dictionary<String, Any>()
        kinkiRegion["regionName"] = "kinki"
        var kinkiPrefectures = Array<Any>()
        kinkiPrefectures.append(contentsOf: ["mie", "shiga", "kyoto", "osaka", "hyogo", "nara", "wakayama"])
        kinkiRegion["prefectures"] = kinkiPrefectures
        
        var chugokuRegion = Dictionary<String, Any>()
        chugokuRegion["regionName"] = "chugoku"
        var chugokuPrefectures = Array<Any>()
        chugokuPrefectures.append(contentsOf: ["tottori", "shimane", "okayama", "hiroshima", "yamaguchi"])
        chugokuRegion["prefectures"] = chugokuPrefectures
        
        var shikokuRegion = Dictionary<String, Any>()
        shikokuRegion["regionName"] = "shikoku"
        var shikokuPrefectures = Array<Any>()
        shikokuPrefectures.append(contentsOf: ["tokushima", "kagawa", "ehime", "kochi"])
        shikokuRegion["prefectures"] = shikokuPrefectures
        
        var kyushuRegion = Dictionary<String, Any>()
        kyushuRegion["regionName"] = "kyushu"
        var kyushuPrefectures = Array<Any>()
        kyushuPrefectures.append(contentsOf: ["hukuoka", "saga", "nagasaki", "kumamoto", "oita", "miyazaki", "kagoshima", "okinawa"])
        kyushuRegion["prefectures"] = kyushuPrefectures
        
        var country = Dictionary<String, Any>()
        country["countryName"] = "japan"
        var regions = Array<Any>()
        regions.append(hokkaidoRegion)
        regions.append(tohokuRegion)
        regions.append(kantoRegion)
        regions.append(chubuRegion)
        regions.append(kinkiRegion)
        regions.append(chugokuRegion)
        regions.append(shikokuRegion)
        regions.append(kyushuRegion)
        country["regions"] = regions
        
        // DictionaryをJSONデータに変換
        let jsonData = try JSONSerialization.data(withJSONObject: country)
        
        // デコーダの作成
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decodableにデコード
        return try decoder.decode(T.self, from: jsonData)
    }
}
