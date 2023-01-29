//
//  DetailsViewController.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/28/23.
//

import UIKit

class DetailsViewController: BaseViewController {
    private var conversionModel: PairConversionModel?
    
    typealias Presenter = DetailsPresenterInput
    var presenter: Presenter?
    var convertButton: UIButton?
    var secondsRemaining = 30
    var timer: Timer?
    
    init(conversionModel: PairConversionModel) {
        self.conversionModel = conversionModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()
        configLables()
    }
    
    func showExpiredAlert() {
        let alert = UIAlertController(title: "Alert", message: "Your quotation has expired.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _  in
            self.moveBack()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func moveBack() {
        self.popModuleInterface(animated: true)
    }
    
    @objc func showSucessScreen() {
        timer?.invalidate()
        let text1 = String(format: "%.2f %@",(conversionModel?.totalAmount ?? 0.0).roundToDecimal(2), conversionModel?.target ?? "")
        let text2 = String(format: "%.2f", conversionModel?.conversionRate?.roundToDecimal(2) ?? 0)
        self.presenter?.showSucessScreen(total: text1, rate: text2)
    }

}


// MARK: - DetailsPresenterOutput

extension DetailsViewController: DetailsPresenterOutput { }


// MARK: - Private

private extension DetailsViewController {
    
    func configButton() {
        convertButton = UIButton(type: .roundedRect)
        if let button = convertButton {
            applyConstraints(for: button)
            button.setTitle("CONVERT", for: .normal)
            button.setEnabled(enable: true)
            button.addTarget(self, action: #selector(showSucessScreen), for: .touchUpInside)
        }
    }
    
    func configLables() {
        let fromlLable = UILabel()
        fromlLable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fromlLable)
        fromlLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        fromlLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        fromlLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        fromlLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        fromlLable.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        fromlLable.font = UIFont.boldSystemFont(ofSize: 18)
        fromlLable.textColor = UIColor.white
        fromlLable.text = String(format: "%d %@", conversionModel?.amount ?? 0, conversionModel?.base ?? "USD")
        fromlLable.textAlignment = .center
        
        let precedesLable = UILabel()
        precedesLable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(precedesLable)
        precedesLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        precedesLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        precedesLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        precedesLable.topAnchor.constraint(equalTo: fromlLable.bottomAnchor).isActive = true
        precedesLable.font = UIFont.systemFont(ofSize: 12)
        precedesLable.textColor = UIColor.white
        precedesLable.text = "precedes"
        precedesLable.textAlignment = .center
        
        let toLable = UILabel()
        toLable.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toLable)
        toLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        toLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        toLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        toLable.topAnchor.constraint(equalTo: precedesLable.bottomAnchor).isActive = true
        toLable.font = UIFont.boldSystemFont(ofSize: 18)
        toLable.textColor = UIColor.white
        toLable.text = String(format: "%.2f %@", conversionModel?.totalAmount?.roundToDecimal(2) ?? 0, conversionModel?.target ?? "")
        toLable.textAlignment = .center
        
        let countDownLabel = UILabel()
        countDownLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(countDownLabel)
        countDownLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        countDownLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        countDownLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        countDownLabel.topAnchor.constraint(equalTo: toLable.bottomAnchor).isActive = true
        countDownLabel.font = UIFont.systemFont(ofSize: 12)
        countDownLabel.textColor = UIColor.white
        countDownLabel.text = "30 Sec left"
        countDownLabel.textAlignment = .center
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
               if self.secondsRemaining > 0 {
                   countDownLabel.text = "\(self.secondsRemaining) sec left"
                   self.secondsRemaining -= 1
               } else {
                   Timer.invalidate()
                   self.showExpiredAlert()
               }
           }
    }
}
