//
//  GradientView.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.3607843137, green: 0.8784313725, blue: 0.7647058824, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gredientLayer = CAGradientLayer()
        gredientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gredientLayer.startPoint = CGPoint(x: 0, y: 0)
        gredientLayer.endPoint = CGPoint(x: 1, y: 1)
        gredientLayer.frame = self.bounds
        self.layer.insertSublayer(gredientLayer, at: 0)
    }

}
