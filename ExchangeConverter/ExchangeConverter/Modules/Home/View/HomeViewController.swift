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

class HomeViewController: UIViewController, BaseModuleInterface {
    
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
        self.presenter?.getCurrencyList(for: nil, completion: { status in
            if status {
                DispatchQueue.main.async {
                    self.sourceTextField.text = "USD"
                }
            }
        })
    }
    
    func salutations_onSelect(selectedText: String) {
        if selectedText == "" {
            print("Hello World")
        } else if selectedText == "Mr." {
            print("Hello Sir")
        } else {
            print("Hello Madame")
        }
    }
    
    // MARK: - Action
    
    @objc func doneClick() {
        amountTextField.resignFirstResponder()
     }
    @objc func cancelClick() {
        amountTextField.resignFirstResponder()
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
