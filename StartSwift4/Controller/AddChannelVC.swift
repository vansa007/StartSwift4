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
    @IBOutlet weak var yConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeModal(guesture:)))
        self.bgView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func closeModal(guesture: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardAppear() {
        self.yConstant.constant = -100.0
    }
    
    @objc func keyboardDisappear() {
        self.yConstant.constant = 0.0
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















