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
        self.changeWeatherImage()
    }

    @IBAction private func reloadButtonDidPress(_ sender: Any) {
        self.changeWeatherImage()
    }
    
    private func changeWeatherImage() {
        
        let weatherImageData = self.fetchWeather()
        
        if let weatherImage = weatherImageData.image {
            self.weatherImageView.image = weatherImage
        }
        
        if let weahterImageColor = weatherImageData.color {
            self.weatherImageView.tintColor = weahterImageColor
        }
        
    }
    
    private func fetchWeather() -> (image: UIImage?, color: UIColor?) {
        
        var weatherImage: UIImage?
        var weatherImageColor: UIColor?
        
        let weather = YumemiWeather.fetchWeather()
        
        switch weather {
        case "sunny":
            weatherImage = UIImage(named: "sunny")
            weatherImageColor = .red
        case "cloudy":
            weatherImage = UIImage(named: "cloudy")
            weatherImageColor = .gray
        case "rainy":
            weatherImage = UIImage(named: "rainy")
            weatherImageColor = .blue
        default:
            weatherImage = nil
            weatherImageColor = nil
        }
        
        return (weatherImage, weatherImageColor)
        
    }
}

