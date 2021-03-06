//
//  WeatherViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/02/18.
//

import UIKit
import YumemiWeather

protocol WeatherViewControllerDelegate: AnyObject {
    func weatherViewControllerDidPressClose(_ viewController: WeatherViewController)
}

final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    weak var delegate: WeatherViewControllerDelegate?
    private let weatherModel: WeatherModel
    
    required init?(coder: NSCoder, weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(foreground(notification:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadWeather()
    }
    
    @objc private func foreground(notification: Notification) {
        self.loadWeather()
    }

    @IBAction private func reloadButtonDidPress(_ sender: Any) {
        self.loadWeather()
    }
    
    @IBAction private func closeButtonDidPress(_ sender: Any) {
        self.delegate?.weatherViewControllerDidPressClose(self)
    }
    
    private func loadWeather() {
        self.activityIndicatorView.startAnimating()
        self.weatherModel.fetchWeather(at: "tokyo", date: Date()) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.activityIndicatorView.stopAnimating()
                self.handleWeather(result)
            }
        }
    }
    
    private func handleWeather(_ result: Result<WeatherResult, Error>) {
        // weatherResultをハンドリング
        switch result {
        case let .success(data):
            // 天気の画像を設定
            let weatherImageResource = self.weatherImageResource(data.weather)
            self.weatherImageView.image = weatherImageResource.image
            self.weatherImageView.tintColor = weatherImageResource.color
            //最高気温と最低気温を設定
            self.minTempLabel.text = String(data.minTemp)
            self.maxTempLabel.text = String(data.maxTemp)
        case let .failure(error):
            let message: String
            switch error {
            case WeatherModelImpl.FetchWeatherError.decodeDataFailed:
                message = "JSONエンコードに失敗"
            case WeatherModelImpl.FetchWeatherError.decodeDataFailed:
                message = "JSONデコードに失敗"
            case YumemiWeatherError.unknownError:
                message = "天気情報の取得に失敗"
            default:
                message = "エラー発生"
            }
            self.showErrorAlert(title: "Error", message: message)
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
