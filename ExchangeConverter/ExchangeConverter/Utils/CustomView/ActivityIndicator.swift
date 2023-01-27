//
//  ActivityIndicator.swift
//  ExchangeConverter
//
//  Created by Balu Naik on 1/27/23.
//

import UIKit

class ActivityIndicator: UIImageView {
    
    
    // MARK: - Initializers
    
    convenience init() {
        let image = UIImage(named: "loader")
        self.init(frame: CGRect(x: 0, y: 0, width: image?.size.width ?? 0, height: image?.size.height ?? 0))
        self.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "loader")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.image = UIImage(named: "loader")
    }
    
    
    // MARK: - Public
    
    override func startAnimating() {
        self.isHidden = false
        if self.layer.animation(forKey: "spinAnimation") == nil {
            let animation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = CGFloat.pi * 2.0
            animation.duration = 0.7
            animation.repeatCount = Float.infinity
            animation.isRemovedOnCompletion = false
            self.layer.add(animation, forKey: "spinAnimation")
        }
    }
    
    override func stopAnimating() {
        self.isHidden = true
        self.layer.removeAnimation(forKey: "spinAnimation")
    }
    
}
