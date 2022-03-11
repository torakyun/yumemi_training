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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    private func bind() {
        self.button.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.showWeatherViewController()
            } catch {
                return
            }
        }
        
    }
    
    private func showWeatherViewController() throws {
        let storyboard = UIStoryboard(name: "ReactiveWeatherViewController", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController { (coder) in
            ReactiveWeatherViewController(coder: coder)
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
