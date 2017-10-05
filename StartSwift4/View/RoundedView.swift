//
//  RoundedView.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/5/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    override func awakeFromNib() {
        setupView()
    }
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }

}
