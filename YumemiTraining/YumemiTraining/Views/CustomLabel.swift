//
//  CustomLabel.swift
//  YumemiTraining
//
//  Created by 水野虎樹 on 2022/04/13.
//

import UIKit

protocol CustomLabelDelegate: class {
    func touchUpInside(customLabel: CustomLabel)
}

class CustomLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.textColor = UIColor.lightGrayColor()
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.textColor = UIColor.blackColor()

        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)
        if CGRectContainsPoint(self.bounds, point) {
            self.touchUpInside()
        }
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        let point = touch.locationInView(self)

        if CGRectContainsPoint(self.bounds, point) {
            self.textColor = UIColor.lightGrayColor()
        }else{
            self.textColor = UIColor.blackColor()
        }
    }

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.textColor = UIColor.blackColor()
    }

    // MARK: - delegate
    weak var delegate: CustomLabelDelegate?
    func touchUpInside() {
        delegate?.touchUpInside(self)
    }

}
