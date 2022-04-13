//
//  PrefectureSelectorViewController.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/06.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

protocol PrefectureSelectorViewControllerDelegate: AnyObject {
    func prefectureSelectorViewControllerDidPressClose(_ viewController: PrefectureSelectorViewController)
    func prefectureSelectorViewControllerDidPressPrefecture(_ viewController: PrefectureSelectorViewController, _ prefectureName: String?)
}

final class PrefectureSelectorViewController: UIViewController {
    private let viewModel: PrefectureSelectorViewModel
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var closeButton: UIButton!
    
    weak var delegate: PrefectureSelectorViewControllerDelegate?
    
    private var country: Country?
    
    // MARK: - UIViewController
    
    required init?(coder: NSCoder) {
        let model = CountryModelImpl()
        self.viewModel = PrefectureSelectorViewModel(model: model)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBind()
    }
    
    // MARK: - Private
    private func setupBind() {
        // input
        self.viewModel.inputs.viewDidAppear <~ self.reactive.viewDidAppear
        
        // output
        self.reactive.loadData <~ self.viewModel.outputs.country
        
        // Closeボタンが押されたとき
        self.closeButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.prefectureSelectorViewControllerDidPressClose(self)
        }
    }
    
    fileprivate func loadData(_ country: Country?) {
        self.country = country
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension PrefectureSelectorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.prefectureSelectorViewControllerDidPressPrefecture(self, self.country?.regions[indexPath.section].prefectures[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension PrefectureSelectorViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.country?.regions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as? PrefectureSelectorSectionHeader else {
            fatalError("Could not find proper header")
        }
        if kind == UICollectionView.elementKindSectionHeader {
            header.changeLabelText(self.country?.regions[indexPath.section].regionName)
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.country?.regions[section].prefectures.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.text = self.country?.regions[indexPath.section].prefectures[indexPath.row]
        cell.backgroundColor = self.setCellBackGroundColorBySection(indexPath.section)
        
        
        return cell
    }
    
    func setCellBackGroundColorBySection(_ section: Int) -> UIColor? {
        switch section {
        case 0:
            return .red
        case 1:
            return .yellow
        case 2:
            return .green
        case 3:
            return .cyan
        case 4:
            return .blue
        case 5:
            return .orange
        case 6:
            return .purple
        case 7:
            return .gray
        default:
            return nil
        }
    }
}

// MARK: - Reactive

extension Reactive where Base == PrefectureSelectorViewController {
    var loadData: BindingTarget<Country?> {
        self.makeBindingTarget { base, country in
            base.loadData(country)
        }
    }
}
