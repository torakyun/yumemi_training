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
        let hokkaidoPrefectures: [String] = ["北海道"]
        let hokkaidoRegion: [String: Any] = ["regionName": "北海道地方", "prefectures": hokkaidoPrefectures]
        // 東北地方
        let tohokuPrefectures: [String] = ["青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"]
        let tohokuRegion: [String: Any] = ["regionName": "東北地方", "prefectures": tohokuPrefectures]
        // 関東地方
        let kantoPrefectures: [String] = ["東京都", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県"]
        let kantoRegion: [String: Any] = ["regionName": "関東地方", "prefectures": kantoPrefectures]
        // 中部地方
        let chubuPrefectures: [String] = ["新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県"]
        let chubuRegion: [String: Any] = ["regionName": "中部地方", "prefectures": chubuPrefectures]
        // 近畿地方
        let kinkiPrefectures: [String] = ["三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
        let kinkiRegion: [String: Any] = ["regionName": "近畿地方", "prefectures": kinkiPrefectures]
        // 中国地方
        let chugokuPrefectures: [String] = ["鳥取県", "島根県", "岡山県", "広島県", "山口県"]
        let chugokuRegion: [String: Any] = ["regionName": "中国地方", "prefectures": chugokuPrefectures]
        // 四国地方
        let shikokuPrefectures: [String] = ["徳島県", "香川県", "愛媛県", "高知県"]
        let shikokuRegion: [String: Any] = ["regionName": "四国地方", "prefectures": shikokuPrefectures]
        // 九州地方
        let kyushuPrefectures: [String] = ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
        let kyushuRegion: [String: Any] = ["regionName": "九州地方", "prefectures": kyushuPrefectures]
        
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
