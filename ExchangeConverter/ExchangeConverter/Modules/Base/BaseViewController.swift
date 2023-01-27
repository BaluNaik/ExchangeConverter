//
//  BaseModule.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

public protocol BaseModuleInterface {
    var presenter: Presenter? { set get }
    
    associatedtype Presenter
}

class BaseViewController: UIViewController {
    
    lazy var activityIndicator: ActivityIndicator = {
        let indicator = ActivityIndicator()
        self.view.addAndCenterSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        return indicator
    }()
    
    func showLoadIndicator(_ show: Bool) {
        self.view.isUserInteractionEnabled = !show
        if show {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
}

extension UIViewController: ModuleTransition {
    
    func pushModuleInterface(controller: UIViewController, animated: Bool) {
        guard let navigationController = self as? UINavigationController else {
            self.navigationController?.pushViewController(controller, animated: animated)
            return
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popModuleInterface(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func presentModuleInterface(controller: UIViewController, animated: Bool) {
        self.present(controller, animated: animated)
    }
    
    func dismissModuleInterface(animated: Bool) {
        self.dismiss(animated: animated, completion: nil)
    }
    
    func popToRootInterface(animated: Bool) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func showOkAlert(errorMsg: String) {
        let alerVc = UIAlertController(title: "Alert!!", message: errorMsg, preferredStyle: .alert)
        alerVc.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alerVc, animated: true)
    }
}



