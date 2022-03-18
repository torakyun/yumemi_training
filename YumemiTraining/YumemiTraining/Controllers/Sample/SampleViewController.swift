//
//  SampleViewController.swift
//  YumemiTraining
//
//  Created by Naoki Odajima on 2022/03/11.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

final class SampleViewController: UIViewController {
    @IBOutlet private weak var sampleTextField: UITextField!
    @IBOutlet private weak var sampleLabel: UILabel!
    @IBOutlet private weak var sampleButton: UIButton!
    @IBOutlet private weak var sampleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    private func bind() {
        /*
         ReactiveSwiftには`イベント`という概念があり、
         変数に変更があった、関数の処理が終わった、などをイベントとして伝達することができる。
         シグナルはプログラム上では、`Signal`という型で表現される。
         そのイベントを監視することで、また次の処理を行う。
         例えば、intSignal: Signal<Int, Never> のようなIntの値が流れるようなイベントがあったとすると,
         ```
         intSignal.observeValues { value in
             print(value)
         }
         ```
         このようにクロージャのように`observe`（監視）することで次の処理を行える。
         
         UIKitについてReactiveSwiftの拡張をおこなったのが、ReactiveCocoa。
         テキストが入力された、ボタンが押された、などのUIのアクションをイベントとして監視できる。
         ```
         button.reactive.controlEvent(.touchUpInside) { _ in
             print("ボタンが押された")
         }
         ```
         `reactive`はReactiveSwiftで拡張されたプロパティにアクセスするためのプロパティ。
         
         またイベントの監視と代入を同時に行うプロパティも存在する。
         例えば、imageSignal: Signal<UIImage, Never> のような画像が流れるイベントがあり、imageViewにセットしたいとき、
         ```
         imageSignal.obesrveValues { image in
             imageView.image = image
         }
         ```
         とすることもできるが、ReactiveCocoaで直接受け取るプロパティが作られている。
         ```
         imageView.reactive.image <~ imageSignal
         ```
         `<~` は、 `observer（監視する側） <~ observable（イベント）` のようにつなぐ演算子。
         
         イベントの型を変更したい場合や、条件でイベントを流さないようにしたい場合は、 `オペレータ` を使用する。
         例えば、IntのイベントをStringに変換して10文字以下の場合のみテキストフィールドに反映させたい場合、
         ```
         textField.reactive.text
         <~ intSignal
             .map { int in
                 // Int -> String へ変換
                 return String(int)
             }
             .filter { string in
                 // stringが10文字以下かどうかでフィルタ
                 return string.count <= 10
             }
         ```
         このようにオペレータをチェーンして書くことで実現できる。
         */
        
        // ラベルのテキスト <~ テキストフィールドで入力されたテキスト
        self.sampleLabel.reactive.text <~ self.sampleTextField.reactive.continuousTextValues
        
        // ImageViewの画像 <~ ボタンを押したときに、テキストフィールドで入力されたテキストの名前の画像があった場合
        // house や sun.min などシステムで用意されている画像の名前を入力してボタンを押してみてください。
        self.sampleImageView.reactive.image
        <~ self.sampleButton.reactive.controlEvents(.touchUpInside)
            .map { [weak self] _ -> UIImage? in
                guard let text = self?.sampleTextField.text else { return nil }
                return UIImage(systemName: text)
            }
            .filter { image -> Bool in
                image != nil
            }
        
        // フォアグラウンドになったときにボタンの色をランダムに変更する
        // compactMap（旧filterMap）はnilの値は通さずに、Optionalを外すオペレータ
        self.sampleButton.reactive.tintColor
        <~ NotificationCenter.default.reactive.notifications(forName: UIApplication.willEnterForegroundNotification, object: nil)
            .compactMap { _ -> UIColor? in
                let colors: [UIColor] = [.red, .blue, .green, .orange, .purple, .yellow]
                return colors.randomElement()
            }
            
    }
}

// MARK: - UITextFieldDelegate

extension SampleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
