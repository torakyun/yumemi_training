//
//  ReactiveViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/11.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

final class ReactiveViewController: UIViewController {
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBind()
    }
    
    // MARK: - Private
    
    private func setupBind() {
        self.button.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            self?.showWeatherViewController()
        }
        
    }
    
    private func showWeatherViewController() {
        let storyboard = UIStoryboard(name: "ReactiveWeatherViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController { (coder) in
            ReactiveWeatherViewController(coder: coder, weatherModel: WeatherModelImpl())
        }
        guard let viewController = viewController else {
            fatalError()
        }
        viewController.delegate = self
        self.present(viewController, animated: true)
    }
}

// MARK: -ReactiveWeatherViewControllerDelegate

extension ReactiveViewController: ReactiveWeatherViewControllerDelegate {
    func reactiveWeatherViewControllerDidPressClose(_ viewController: ReactiveWeatherViewController) {
        self.dismiss(animated: true)
    }
}
