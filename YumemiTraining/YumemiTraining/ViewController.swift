//
//  ViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/02/18.
//

import UIKit
import YumemiWeather

final class ViewController: UIViewController {
    
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadWeather()
    }

    @IBAction private func reloadButtonDidPress(_ sender: Any) {
        self.loadWeather()
    }
    
    private func loadWeather() {
        
        do {
            // 天気予報に必要なパラメータをJSON文字列で保持
            let jsonObj: [String: Any] = [
                "area": "tokyo",
                "date": "2020-04-01T12:00:00+09:00"
            ]
            
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObj, options: [])
            let jsonStr = String(bytes: jsonData, encoding: .utf8)!
            
            // 天気予報をAPIから取得
            let weatherJsonStr = try YumemiWeather.fetchWeather(jsonStr)
            let weatherData: Data =  weatherJsonStr.data(using: String.Encoding.utf8)!
            let weatherJsonObj = try JSONSerialization.jsonObject(with: weatherData) as! Dictionary<String, Any>
            
            // 天気の画像を設定
            let weather = weatherJsonObj["weather"] as! String
            let weatherImageResource = self.weatherImageResource(weather)
            self.weatherImageView.image = weatherImageResource.image
            self.weatherImageView.tintColor = weatherImageResource.color
            
            //最高気温と最低気温を設定
            self.maxTempLabel.text = String(weatherJsonObj["max_temp"] as! Int)
            self.minTempLabel.text = String(weatherJsonObj["min_temp"] as! Int)
            
        } catch YumemiWeatherError.invalidParameterError {
            self.showErrorAlert(title: "天気情報の取得に失敗", message: "invalidParameterError")
        } catch YumemiWeatherError.unknownError {
            self.showErrorAlert(title: "天気情報の取得に失敗", message: "unknownError")
        } catch {
            print(error)
        }
        
    }
    
    private func weatherImageResource(_ weather: String) -> (image: UIImage?, color: UIColor?) {
        
        switch weather {
        case "sunny":
            return (UIImage(named: "sunny"), .red)
        case "cloudy":
            return (UIImage(named: "cloudy"), .gray)
        case "rainy":
            return (UIImage(named: "rainy"), .blue)
        default:
            return (nil, nil)
        }
        
    }
    
    private func showErrorAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

