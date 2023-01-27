//
//  HomeViewController.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

enum CurrentTextField: Int {
    case none
    case source
    case destination
    case amount
}

class HomeViewController: BaseViewController, BaseModuleInterface {
    
    typealias Presenter = HomePresenterInput
    var presenter: Presenter?
    @IBOutlet weak var sourceTextField : UITextField!
    @IBOutlet weak var destinationTextField : UITextField!
    @IBOutlet weak var amountTextField : UITextField!
    @IBOutlet weak var calcButton : UIButton!
    private var activeTextField = CurrentTextField.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceTextField.delegate = self
        destinationTextField.delegate = self
        amountTextField.delegate = self
        
        // Do any additional setup after loading the view.
        sourceTextField.setRightView()
        destinationTextField.setRightView()
        // ToolBar
        let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width: self.view.frame.width, height:50))
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
        amountTextField.inputAccessoryView = toolBar
        
        calcButton.setEnabled(enable: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.eventLoadData(for: "USD")
    }
    
    func salutations_onSelect(selectedText: String) {
        if self.activeTextField == .source,
           let base = self.presenter?.currentBase, selectedText != base {
            self.eventLoadData(for: selectedText)
            self.destinationTextField.text = ""
        }
    }
    
    func eventLoadData(for source: String) {
        self.showLoadIndicator(true)
        self.presenter?.getCurrencyList(for: source, completion: {[weak self] errorMsg in
            DispatchQueue.main.async {
                self?.showLoadIndicator(false)
                if errorMsg == nil {
                    self?.sourceTextField.text = source
                } else {
                    self?.showOkAlert(errorMsg: errorMsg ?? "")
                }
            }
        })
    }
    
    func validateAmount() {
        if let text = amountTextField.text,
           let value = Int(text), value > 0 {
            calcButton.setEnabled(enable: true)
        } else {
            calcButton.setEnabled(enable: false)
        }
    }
    
    
    // MARK: - Action
    
    @objc func doneClick() {
        amountTextField.resignFirstResponder()
        validateAmount()
     }
    @objc func cancelClick() {
        amountTextField.resignFirstResponder()
        validateAmount()
    }
    
    @IBAction func calculatedAmount() {
        let result = self.presenter?.calculateAmount(amount: Int(amountTextField.text!)! , currency: self.destinationTextField.text!)
        self.showOkAlert(errorMsg:"\(result!.0) \(result!.1)")
    }

}


extension HomeViewController: HomePresenterOutput {
    
}


extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == sourceTextField {
            self.activeTextField = .source
            sourceTextField.loadDropdownData(data: self.presenter?.getCurrencyCodes(for: .source) ?? [] , selectionHandler: salutations_onSelect)
        } else if textField == destinationTextField {
            self.activeTextField = .destination
            destinationTextField.loadDropdownData(data: self.presenter?.getCurrencyCodes(for: .destination) ?? [] , selectionHandler: salutations_onSelect)
        } else {
            self.activeTextField = .amount
        }
    }
    
}
