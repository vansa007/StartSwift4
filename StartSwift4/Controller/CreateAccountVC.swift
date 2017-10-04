//
//  CreateAccountVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    //outlet
    @IBOutlet weak var usernameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var avatarUser: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Action event
    @IBAction func createAccountAction(_ sender: UIButton) {
        guard let email = emailTf.text, emailTf.text?.isEmpty == false else { return }
        guard let pass = passwordTf.text, passwordTf.text?.isEmpty == false else { return }
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        print("loged in user!", AuthService.instance.authToken)
                    }
                })
            }
        }
    }
    @IBAction func pickAvatarAction(_ sender: UIButton) {
    }
    @IBAction func pickBGColorAction(_ sender: UIButton) {
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}















