//
//  HomeViewController.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/24/23.
//

import UIKit

class HomeViewController: UIViewController, BaseModuleInterface {
    
    typealias Presenter = HomePresenterInput
    var presenter: Presenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


extension HomeViewController: HomePresenterOutput {
    
}
