//
//  PrefectureSelectorSectionHeader.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/06.
//

import UIKit

final class PrefectureSelectorSectionHeader: UICollectionReusableView {
    @IBOutlet private weak var label: UILabel!
    
    func changeLabelText(_ text: String?) {
        self.label.text = text
    }
}
