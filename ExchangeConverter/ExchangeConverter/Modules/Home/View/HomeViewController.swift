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
    
    var sourceField: UITextField?
    var destinationField: UITextField?
    var amountField : UITextField?
    var calcButton: UIButton!
    var logoImageView: UIImageView!
    var transferImageView: UIImageView!
    private var activeTextField = CurrentTextField.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configLogoImage()
        configButton()
        configTextFields()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.destinationField?.text = ""
        self.amountField?.text = ""
        self.validateAmount()
        if presenter?.isExpried ?? true {
            self.eventLoadData(for: self.presenter?.currentBase ?? "USD")
        }
    }
    
    func salutations_onSelect(selectedText: String) {
        if self.activeTextField == .source,
           let base = self.presenter?.currentBase, selectedText != base {
            self.eventLoadData(for: selectedText)
            self.destinationField?.text = ""
        }
    }
    
    func eventLoadData(for source: String) {
        self.showLoadIndicator(true)
        self.presenter?.eventLoadData(for: source, completion: {[weak self] errorMsg in
            DispatchQueue.main.async {
                self?.showLoadIndicator(false)
                if errorMsg == nil {
                    self?.sourceField?.text = source
                } else {
                    self?.showOkAlert(errorMsg: errorMsg ?? "")
                }
            }
        })
    }
    
    func validateAmount() {
        if (sourceField?.isValidData() ?? false) && (destinationField?.isValidData() ?? false),
           let text = amountField?.text,
           let value = Int(text), value > 0 {
            calcButton?.setEnabled(enable: true)
        } else {
            calcButton?.setEnabled(enable: false)
        }
    }
}


// MARK: - HomePresenterOutput

extension HomeViewController: HomePresenterOutput {
    func showErrorAlert(errorMsg: String) {
        self.showOkAlert(errorMsg: errorMsg)
    }
}


// MARK: - UITextFieldDelegate

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == sourceField {
            self.activeTextField = .source
            sourceField?.loadDropdownData(data: self.presenter?.getCurrencyCodes(for: .source) ?? [] , selectionHandler: salutations_onSelect)
        } else if textField == destinationField {
            self.activeTextField = .destination
            destinationField?.loadDropdownData(data: self.presenter?.getCurrencyCodes(for: .destination) ?? [] , selectionHandler: salutations_onSelect)
        } else {
            self.activeTextField = .amount
        }
    }
}



// MARK: - Private

private extension HomeViewController {
    
    func configButton() {
        calcButton = UIButton(type: .roundedRect)
        if let button = calcButton {
            super.applyConstraints(for: button)
            button.setTitle("CALCULATE", for: .normal)
            button.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        }
    }
    
    func configLogoImage() {
        logoImageView = UIImageView(image: UIImage(named: "exchange"))
        if let logo = logoImageView {
            logo.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(logo)
            logo.heightAnchor.constraint(equalToConstant: 150).isActive = true
            logo.widthAnchor.constraint(equalToConstant: 150).isActive = true
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
    }
    
    func configTextFields() {
        transferImageView = UIImageView(image: UIImage(named: "transfer"))
        if let icon = transferImageView {
            icon.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(icon)
            icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
            icon.widthAnchor.constraint(equalToConstant: 30).isActive = true
            icon.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30).isActive = true
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        sourceField = UITextField()
        sourceField?.borderStyle = .roundedRect
        if let source = sourceField {
            source.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(source)
            source.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            source.heightAnchor.constraint(equalToConstant: 40).isActive = true
            source.trailingAnchor.constraint(equalTo: transferImageView.leadingAnchor, constant: -10).isActive = true
            source.centerYAnchor.constraint(equalTo: transferImageView.centerYAnchor).isActive = true
            source.delegate = self
            source.setRightView()
        }
        
        destinationField = UITextField()
        destinationField?.borderStyle = .roundedRect
        if let dest = destinationField {
            dest.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(dest)
            dest.leadingAnchor.constraint(equalTo: transferImageView.trailingAnchor, constant: 10).isActive = true
            dest.heightAnchor.constraint(equalToConstant: 40).isActive = true
            dest.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            dest.centerYAnchor.constraint(equalTo: transferImageView.centerYAnchor).isActive = true
            dest.delegate = self
            dest.setRightView()
        }
        
        amountField = UITextField()
        amountField?.borderStyle = .roundedRect
        if let amount = amountField {
            amount.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(amount)
            amount.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            amount.heightAnchor.constraint(equalToConstant: 40).isActive = true
            amount.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            amount.topAnchor.constraint(equalTo: sourceField!.bottomAnchor,constant: 50).isActive = true
            amount.placeholder = "Enter Amount"
            amount.delegate = self
            amount.keyboardType = .numberPad
            configToolBar(for: amount)
            
            let lable = UILabel()
            lable.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(lable)
            lable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            lable.heightAnchor.constraint(equalToConstant: 25).isActive = true
            lable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
            lable.bottomAnchor.constraint(equalTo: amount.topAnchor,constant: 0).isActive = true
            lable.font = UIFont.boldSystemFont(ofSize: 16)
            lable.textColor = UIColor.white
            lable.text = "Amount"
        }
        
    }
    
    func configToolBar(for textField: UITextField) {
        // ToolBar
        let toolBar = UIToolbar(frame:CGRect(x:0, y:0, width: self.view.frame.width, height:50))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
}


// MARK: - @objc Actions

@objc extension HomeViewController {
    
    func doneClick() {
        amountField?.resignFirstResponder()
        validateAmount()
     }
    
    func cancelClick() {
        amountField?.resignFirstResponder()
        validateAmount()
    }
    
    func showDetails() {
        if let _ = self.sourceField?.text,
           let to = self.destinationField?.text,
           let amountText = amountField?.text,
           let amount = Int(amountText), amount > 0 {
            self.presenter?.calculateAmount(amount: amount, currency: to)
        }
    }    
}
