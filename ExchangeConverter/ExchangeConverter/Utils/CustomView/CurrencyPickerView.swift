//
//  CurrencyPickerView.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/26/23.
//

import UIKit

class CurrencyPickerView: UIPickerView {
    var data : [String]!
    var pickerTextField : UITextField!
    var selectionHandler: ((String) ->Void)?
    var currentCode = "USD"
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRectZero)
        
        self.data = pickerData
        self.pickerTextField = dropdownField
        self.currentCode = dropdownField.text ?? "USD"
 
        self.delegate = self
        self.dataSource = self
        DispatchQueue.main.async {
            if !self.data.isEmpty && self.pickerTextField.text == nil {
                self.pickerTextField.text = self.data[0]
                self.pickerTextField.isEnabled = true
            }
        }
        customizeUi()
    }
    
    convenience init(pickerData: [String], dropdownField: UITextField, selectionHandler:@escaping (String) -> Void) {
        self.init(pickerData: pickerData, dropdownField: dropdownField)
        self.selectionHandler = selectionHandler
    }
    
    private func customizeUi() {
        self.backgroundColor = .white
        // ToolBar
        let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width:self.frame.width, height:50))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pickerTextField.inputAccessoryView = toolBar
    }
    
    
    // MARK: - Action
    
    @objc func doneClick() {
        selectionHandler?(self.pickerTextField.text!)
        pickerTextField.resignFirstResponder()
     }
    @objc func cancelClick() {
        self.pickerTextField.text = currentCode
        pickerTextField.resignFirstResponder()
    }
}


// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension CurrencyPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = data[row]
        //selectionHandler?(self.pickerTextField.text!)
    }
    
}
