//
//  SampleViewController.swift
//  YumemiTraining
//
//  Created by Naoki Odajima on 2022/03/11.
//

import UIKit

final class SampleViewController: UIViewController {
    @IBOutlet private weak var sampleTextField: UITextField!
    @IBOutlet private weak var sampleLabel: UILabel!
    @IBOutlet private weak var sampleButton: UIButton!
    @IBOutlet private weak var sampleImageView: UIImageView!
}

// MARK: - UITextFieldDelegate

extension SampleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
