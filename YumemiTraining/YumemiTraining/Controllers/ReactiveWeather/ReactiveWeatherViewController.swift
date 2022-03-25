//
//  ReactiveWeatherViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/11.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import YumemiWeather

protocol ReactiveWeatherViewControllerDelegate: AnyObject {
    func reactiveWeatherViewControllerDidPressClose(_ viewController: ReactiveWeatherViewController)
}

final class ReactiveWeatherViewController: UIViewController {
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var reloadButton: UIButton!
    
    weak var delegate: ReactiveWeatherViewControllerDelegate?
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
        self.bind()
    }
    
    private func bind() {
        // 天気情報のリロード
        // リロードを行うシグナル
        let willReloadSignal = Signal.merge(
            // フォアグラウンドに戻った
            NotificationCenter.default.reactive
                .notifications(forName: UIApplication.willEnterForegroundNotification, object: nil)
                .map { _ in },
            // viewDidAppearが実行された
            self.reactive.viewDidAppear,
            // Reloadボタンが押された
            self.reloadButton.reactive.controlEvents(.touchUpInside).map { _ in }
        )
        // APIからデータを取得
        self.weatherModel.fetchWeatherAction <~ willReloadSignal.map(value: (at: "tokyo", date: Date()))
        self.activityIndicatorView.reactive.isAnimating <~ self.weatherModel.fetchWeatherAction.isExecuting
        // Viewに反映
        self.reactive.updateWeather <~ self.weatherModel.fetchWeatherAction.values
        self.reactive.showError <~ self.weatherModel.fetchWeatherAction.errors
        
        // フォアグラウンドに戻った時にUIAlertControllerが表示されていたら閉じる
        NotificationCenter.default.reactive
            .notifications(forName: UIApplication.willEnterForegroundNotification, object: nil)
            .observeValues { [weak self] _ in
                self?.presentedViewController?.dismiss(animated: false)
            }
        
        // Closeボタンが押された時の処理
        self.closeButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.reactiveWeatherViewControllerDidPressClose(self)
        }
    }
    
    fileprivate func updateWeather(from weather: WeatherResult) {
            // 天気の画像を設定
            let weatherImageResource = self.weatherImageResource(weather.weather)
            self.weatherImageView.image = weatherImageResource.image
            self.weatherImageView.tintColor = weatherImageResource.color
            //最高気温と最低気温を設定
            self.minTempLabel.text = String(weather.minTemp)
            self.maxTempLabel.text = String(weather.maxTemp)
    }
    
    fileprivate func showError(_ error: Error) {
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

// MARK: - Reactive

private extension Reactive where Base == ReactiveWeatherViewController {
    var updateWeather: BindingTarget<WeatherResult> {
        self.makeBindingTarget { (base: ReactiveWeatherViewController, weatherResult: WeatherResult) in
            base.updateWeather(from: weatherResult)
        }
    }
    var showError: BindingTarget<Error> {
        self.makeBindingTarget { (base: ReactiveWeatherViewController, error: Error) in
            base.showError(error)
        }
    }
}
