//
//  ViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/03/04.
//

import UIKit

final class ViewController: UIViewController {
    @IBAction private func showWeatherButtonPressed(_ sender: Any) {
        try? self.showWeatherViewController()
    }
    
    private func showWeatherViewController() throws {
        
        let storyboard = UIStoryboard(name: "WeatherViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController { (coder) in
            WeatherViewController(coder: coder, weatherModel: WeatherModelImpl())
        }
        guard let viewController = viewController else {
            fatalError()
        }
        viewController.delegate = self
        self.present(viewController, animated: true)
    }
}

// MARK: - WeatherViewControllerDelegate

extension ViewController: WeatherViewControllerDelegate {
    func weatherViewControllerDidPressClose(_ viewController: WeatherViewController) {
        self.dismiss(animated: true)
    }
}
