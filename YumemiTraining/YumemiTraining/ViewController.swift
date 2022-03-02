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
        
        var weatherImage: UIImage?
        var weatherImageColor: UIColor?
        
        do {
            
            let weather = try YumemiWeather.fetchWeather(at: "tokyo")
            
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
            
        } catch YumemiWeatherError.invalidParameterError {
            
            let alert = UIAlertController(title: "天気情報の取得に失敗", message: "invalidParameterError", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                
            }
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        } catch YumemiWeatherError.unknownError {
        
            let alert = UIAlertController(title: "天気情報の取得に失敗", message: "unknownError", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                
            }
            alert.addAction(cancelAction)
            present(alert, animated: true)
        
        } catch let error {
            print(error)
        }
        
        return (weatherImage, weatherImageColor)
        
    }
}

