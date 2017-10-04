//
//  LoginVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //visual
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func myAlert(status: Int, message: String, title: String, loginButton: RoundedButton) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let checkBtn = UIAlertAction(title: "Check", style: .cancel) { (action) in
            self.emailTf.text = ""
            self.passwordTf.text = ""
        }
        let okBtn = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: {
                //reload data
            })
        }
        if status == 1 {
            alert.addAction(okBtn)
        }else {
            alert.addAction(checkBtn)
        }
        self.present(alert, animated: true) {
            loginButton.loadingIndicator(show: false)
        }
    }
    
    //MARK: event handler
    @IBAction func unWindFromCreateAccount(unWindSegue: UIStoryboardSegue) {}
    @IBAction func loginAction(_ sender: RoundedButton) {
        self.view.endEditing(true)
        sender.loadingIndicator(show: true)
        if let email = emailTf.text, let password = passwordTf.text, email.isEmpty || password.isEmpty {
            self.myAlert(status: 0, message: "Please check email or password again.", title: "Warning", loginButton: sender)
        }else {
            AuthService.instance.loginUser(email: emailTf.text!, password: passwordTf.text!, completion: { (success) in
                if success {
                    self.myAlert(status: 1, message: "Logged successfully!", title: ":)", loginButton: sender)
                }else {
                    self.myAlert(status: 2, message: "Do you want to hack?", title: ":(", loginButton: sender)
                }
            })
        }
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


















