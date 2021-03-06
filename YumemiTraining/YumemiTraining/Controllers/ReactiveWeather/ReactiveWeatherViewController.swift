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
    private let viewModel: ReactiveWeatherViewModel
    
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var minTempLabel: UILabel!
    @IBOutlet private weak var maxTempLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var reloadButton: UIButton!
    
    weak var delegate: ReactiveWeatherViewControllerDelegate?
    
    // MARK: - UIViewController
    
    required init?(coder: NSCoder) {
        let model = WeatherModelImpl()
        self.viewModel = ReactiveWeatherViewModel(model: model)
        super.init(coder: coder)
    }
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBind()
    }
    
    // MARK: - Private
    
    private func setupBind() {
        // Viewで発生したイベント
        self.viewModel.inputs.viewDidAppear <~ self.reactive.viewDidAppear
        self.viewModel.inputs.reloadButtonDidPress <~ self.reloadButton.reactive.controlEvents(.touchUpInside).map { _ in }
        
        // Modelの処理をViewに反映
        // インジケーター
        self.activityIndicatorView.reactive.isAnimating <~ self.viewModel.outputs.isActivityIndicatorViewAnimating
        // 天気の画像
        self.weatherImageView.reactive.image <~ self.viewModel.image
        self.weatherImageView.reactive.tintColor <~ self.viewModel.color
        // 気温
        self.minTempLabel.reactive.text <~ self.viewModel.minTemp
        self.maxTempLabel.reactive.text <~ self.viewModel.maxTemp
        // エラーアラート
        self.reactive.showErrorAlert <~ self.viewModel.outputs.showErrorAlert
        
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
    
    fileprivate func showErrorAlert(message: String?) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}

// MARK: - Reactive

private extension Reactive where Base == ReactiveWeatherViewController {
    var showErrorAlert: BindingTarget<String> {
        self.makeBindingTarget { base, message in
            base.showErrorAlert(message: message)
        }
    }
}
