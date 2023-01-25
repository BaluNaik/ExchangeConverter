//
//  ModuleTransition.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

protocol ModuleTransition {
    
    func pushModuleInterface(controller: UIViewController, animated: Bool)
    func popModuleInterface(animated: Bool)
    func presentModuleInterface(controller: UIViewController, animated: Bool)
    func dismissModuleInterface(animated: Bool)
    func popToRootInterface(animated: Bool)
    
}
