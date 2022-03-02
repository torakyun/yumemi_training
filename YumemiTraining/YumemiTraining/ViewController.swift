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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWeather()
    }

    @IBAction private func reloadButtonDidPress(_ sender: Any) {
        self.loadWeather()
    }
    
    private func loadWeather() {
        
        do {
            
            let weather = try YumemiWeather.fetchWeather(at: "tokyo")
            let weatherImageResource = self.weatherImageResource(weather)
            self.weatherImageView.image = weatherImageResource.image
            self.weatherImageView.tintColor = weatherImageResource.color
            
        } catch YumemiWeatherError.invalidParameterError {
            
            let alert = UIAlertController(title: "天気情報の取得に失敗", message: "invalidParameterError", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        } catch YumemiWeatherError.unknownError {
            
            let alert = UIAlertController(title: "天気情報の取得に失敗", message: "unknownError", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        } catch let error {
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
}

