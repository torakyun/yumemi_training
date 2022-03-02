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
        
        let weather = YumemiWeather.fetchWeather()
        let weatherImageResource = self.weatherImageResource(weather)
        self.weatherImageView.image = weatherImageResource.image
        self.weatherImageView.tintColor = weatherImageResource.color
        
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

