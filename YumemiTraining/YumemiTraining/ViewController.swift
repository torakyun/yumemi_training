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
    private var weahterImage: UIImage?
    private var weahterImageColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.changeWeatherImage()
    }

    @IBAction func reloadButtonDidPress(_ sender: Any) {
        self.changeWeatherImage()
    }
    
    private func changeWeatherImage() {
        
        let weatherImageData = self.fetchWeather()
        
        if let weahterImage = weatherImageData.image {
            self.weahterImage = weahterImage
        }
        self.weatherImageView.image = self.weahterImage
        
        if let weahterImageColor = weatherImageData.color {
            self.weahterImageColor = weahterImageColor
        }
        self.weatherImageView.tintColor = self.weahterImageColor
        
    }
    
    private func fetchWeather() -> (image: UIImage?, color: UIColor?) {
        
        let weather = YumemiWeather.fetchWeather()
        var weatherImage: UIImage?
        var weatherImageColor: UIColor?
        
        if weather == "sunny" {
            weahterImage = UIImage(named: "sunny")
            weatherImageColor = .red
        } else if weather == "cloudy" {
            weahterImage = UIImage(named: "cloudy")
            weatherImageColor = .gray
        } else if weather == "rainy" {
            weahterImage = UIImage(named: "rainy")
            weatherImageColor = .blue
        } else {
            weatherImage = nil
            weatherImageColor = nil
        }
        
        return (weatherImage, weatherImageColor)
        
    }
}

