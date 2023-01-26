//
//  UITextField+Extension.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import UIKit

extension UITextField {

    func setRightView() {
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        iconView.image = UIImage(named: "down")
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        iconContainerView.addSubview(iconView)
        self.rightView = iconContainerView
        self.rightViewMode = .always
    }
    
    func loadDropdownData(data: [String], selectionHandler:@escaping (String) -> Void) {
        self.inputView = CurrencyPickerView(pickerData: data, dropdownField: self, selectionHandler: selectionHandler)
    }
}


