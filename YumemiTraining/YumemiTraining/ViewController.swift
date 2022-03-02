//
//  ViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/02/18.
//

import UIKit
import YumemiWeather

class ViewController: UIViewController {
    
    @IBOutlet private weak var weatherImageView: UIImageView!
    private var weatherImage: UIImage?
    private var weatherImageColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeWeatherImage()
    }

    @IBAction func reloadButtonDidPress(_ sender: Any) {
        self.changeWeatherImage()
    }
    
    private func changeWeatherImage() {
        
        let weatherImageData = self.fetchWeather()
        
        if let weatherImage = weatherImageData.image {
            self.weatherImage = weatherImage
        }
        self.weatherImageView.image = self.weatherImage
        
        if let weahterImageColor = weatherImageData.color {
            self.weatherImageColor = weahterImageColor
        }
        self.weatherImageView.tintColor = self.weatherImageColor
        
    }
    
    private func fetchWeather() -> (image: UIImage?, color: UIColor?) {
        
        var weatherImage: UIImage?
        var weatherImageColor: UIColor?
        
        let weather = YumemiWeather.fetchWeather()
        
        if weather == "sunny" {
            weatherImage = UIImage(named: "sunny")
            weatherImageColor = .red
        } else if weather == "cloudy" {
            weatherImage = UIImage(named: "cloudy")
            weatherImageColor = .gray
        } else if weather == "rainy" {
            weatherImage = UIImage(named: "rainy")
            weatherImageColor = .blue
        } else {
            weatherImage = nil
            weatherImageColor = nil
        }
        
        return (weatherImage, weatherImageColor)
        
    }
}

