//
//  CountryAPI.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

import Foundation

enum CountryAPI {
    public static func fetchCountry<T: Decodable>() throws -> T {
        
        var hokkaidoRegion = Array<Any>()
        hokkaidoRegion.append(contentsOf: ["hokkaido"])
        var tohokuRegion = Array<Any>()
        tohokuRegion.append(contentsOf: ["aomori", "iwate", "miyagi", "akita", "yamagata", "hukusima"])
        var kantoRegion = Array<Any>()
        kantoRegion.append(contentsOf: ["tokyo", "ibaraki", "tochigi", "gunma", "saitama", "chiba", "kanagawa"])
        var chubuRegion = Array<Any>()
        chubuRegion.append(contentsOf: ["nigata", "toyama", "ishikawa", "hukui", "yamanashi", "nagano", "gihu", "shizuoka", "aichi"])
        var kinkiRegion = Array<Any>()
        kinkiRegion.append(contentsOf: ["mie", "shiga", "kyoto", "osaka", "hyogo", "nara", "wakayama"])
        var chugokuRegion = Array<Any>()
        chugokuRegion.append(contentsOf: ["tottori", "shimane", "okayama", "hiroshima", "yamaguchi"])
        var shikokuRegion = Array<Any>()
        shikokuRegion.append(contentsOf: ["tokushima", "kagawa", "ehime", "kochi"])
        var kyushuRegion = Array<Any>()
        kyushuRegion.append(contentsOf: ["hukuoka", "saga", "nagasaki", "kumamoto", "oita", "miyazaki", "kagoshima", "okinawa"])
        
        var regions = Dictionary<String, Any>()
        regions["hokkaido"] = hokkaidoRegion
        regions["tohoku"] = tohokuRegion
        regions["kanto"] = kantoRegion
        regions["chubu"] = chubuRegion
        regions["kinki"] = kinkiRegion
        regions["chugoku"] = chugokuRegion
        regions["shikoku"] = shikokuRegion
        regions["kyusyu"] = kyushuRegion
        
        // DictionaryをJSONデータに変換
        let jsonData = try JSONSerialization.data(withJSONObject: regions)
        // JSONデータを文字列に変換
        let jsonStr = String(bytes: jsonData, encoding: .utf8)!
        print(jsonStr)
        
        // デコーダの作成
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decodableにデコード
        return try decoder.decode(T.self, from: jsonData)
    }
}
