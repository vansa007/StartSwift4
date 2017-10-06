//
//  AddChannelVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/6/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var bgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeModal(guesture:)))
        self.bgView.addGestureRecognizer(tap)
    }
    
    @objc func closeModal(guesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func createChannelAction(_ sender: RoundedButton) {
        guard let chName = self.name.text, name.text?.isEmpty == false else { return }
        guard let chDesc = self.desc.text, desc.text?.isEmpty == false else { return }
        SocketService.instance.addChannel(name: chName, desc: chDesc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //textfield delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}















