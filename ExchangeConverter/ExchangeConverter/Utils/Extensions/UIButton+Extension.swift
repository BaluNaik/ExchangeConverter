//
//  UIButton+Extension.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import UIKit

extension UIButton {
    
    func setEnabled(enable: Bool) {
        self.isEnabled = enable
        self.backgroundColor = enable ? UIColor.btnEnabledColor : UIColor.btnDisabledColor
    }
    
}
