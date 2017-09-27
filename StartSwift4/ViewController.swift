//
//  ViewController.swift
//  StartSwift4
//
//  Created by Vansa Pha on 9/27/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //visual connection
    @IBOutlet weak var darkBlueBG: UIImageView!
    @IBOutlet weak var powerBtn: UIButton!
    @IBOutlet weak var cloudHolder: UIView!
    @IBOutlet weak var rocket: UIImageView!
    @IBOutlet weak var liiv: UILabel!
    @IBOutlet weak var kbBank: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func powerAction(_ sender: UIButton) {
        cloudHolder.isHidden = false
        darkBlueBG.isHidden = true
        powerBtn.isHidden = true
        UIView.animate(withDuration: 2.3, animations: {
            self.rocket.frame = CGRect(x: 0, y: 160, width: 375, height: 402)
        }) { (finished) in
            self.liiv.isHidden = false
            self.kbBank.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

