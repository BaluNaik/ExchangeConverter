//
//  UIView+Extension.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/27/23.
//

import UIKit

extension UIView {
    
    func addAndCenterSubview(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subview)
        let parentView = self
        let xConstraint = NSLayoutConstraint(item: subview,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: parentView,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0.0)
        let yConstraint = NSLayoutConstraint(item: subview,
                                             attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: parentView,
                                             attribute: .centerY,
                                             multiplier: 1.0,
                                             constant: 0.0)
        self.addConstraints([xConstraint, yConstraint])
    }
}
