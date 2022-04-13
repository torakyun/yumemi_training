//
//  CountryAPI.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/01.
//

import Foundation

enum CountryAPI {
    static func fetchCountry() throws -> Country {
        // 北海道地方
        let hokkaidoPrefectures: [String] = ["hokkaido"]
        let hokkaidoRegion: [String: Any] = ["regionName": "hokkaido", "prefectures": hokkaidoPrefectures]
        // 東北地方
        let tohokuPrefectures: [String] = ["aomori", "iwate", "miyagi", "akita", "yamagata", "hukusima"]
        let tohokuRegion: [String: Any] = ["regionName": "tohoku", "prefectures": tohokuPrefectures]
        // 関東地方
        let kantoPrefectures: [String] = ["tokyo", "ibaraki", "tochigi", "gunma", "saitama", "chiba", "kanagawa"]
        let kantoRegion: [String: Any] = ["regionName": "kanto", "prefectures": kantoPrefectures]
        // 中部地方
        let chubuPrefectures: [String] = ["nigata", "toyama", "ishikawa", "hukui", "yamanashi", "nagano", "gihu", "shizuoka", "aichi"]
        let chubuRegion: [String: Any] = ["regionName": "chubu", "prefectures": chubuPrefectures]
        // 近畿地方
        let kinkiPrefectures: [String] = ["mie", "shiga", "kyoto", "osaka", "hyogo", "nara", "wakayama"]
        let kinkiRegion: [String: Any] = ["regionName": "kinki", "prefectures": kinkiPrefectures]
        // 中国地方
        let chugokuPrefectures: [String] = ["tottori", "shimane", "okayama", "hiroshima", "yamaguchi"]
        let chugokuRegion: [String: Any] = ["regionName": "chugoku", "prefectures": chugokuPrefectures]
        // 四国地方
        let shikokuPrefectures: [String] = ["tokushima", "kagawa", "ehime", "kochi"]
        let shikokuRegion: [String: Any] = ["regionName": "shikoku", "prefectures": shikokuPrefectures]
        // 九州地方
        let kyushuPrefectures: [String] = ["hukuoka", "saga", "nagasaki", "kumamoto", "oita", "miyazaki", "kagoshima", "okinawa"]
        let kyushuRegion: [String: Any] = ["regionName": "kyushu", "prefectures": kyushuPrefectures]
        
        // 日本の地方区分
        let regions: [Any] = [hokkaidoRegion, tohokuRegion, kantoRegion, chubuRegion, kinkiRegion, chugokuRegion, shikokuRegion, kyushuRegion]
        let country: [String: Any] = ["countryName": "japan", "regions": regions]
        
        // DictionaryをJSONデータに変換
        let jsonData = try JSONSerialization.data(withJSONObject: country)
        
        // デコーダの作成
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        // Decodableにデコード
        return try decoder.decode(Country.self, from: jsonData)
    }
}
