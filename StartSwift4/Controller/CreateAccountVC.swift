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
    @IBOutlet weak var createAccountLink: RoundedButton!
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line3: UIView!
    //declear
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UserDataService.instance.avatarName.isEmpty {
            avatarUser.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                avatarUser.backgroundColor = UIColor.lightGray
            }
        }else {
            avatarUser.image = UIImage(named: avatarName)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTab))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Action event
    @IBAction func createAccountAction(_ sender: RoundedButton) {
        sender.loadingIndicator(show: true)
        guard let name = usernameTf.text, usernameTf.text?.isEmpty == false else { return }
        guard let email = emailTf.text, emailTf.text?.isEmpty == false else { return }
        guard let pass = passwordTf.text, passwordTf.text?.isEmpty == false else { return }
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: pass, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { (success) in
                            if success {
                                print(UserDataService.instance.name)
                                NotificationCenter.default.post(name: SET_USER_INFO, object: nil)
                                self.performSegue(withIdentifier: GO_HOME, sender: nil)
                            }
                        })
                    }
                })
            }else {
                
            }
            sender.loadingIndicator(show: false)
        }
    }
    @IBAction func pickAvatarAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: GO_AVATAR_PICKER, sender: bgColor)
    }
    @IBAction func pickBGColorAction(_ sender: UIButton) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        self.avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.avatarUser.backgroundColor = self.bgColor
            self.createAccountLink.backgroundColor = self.bgColor
            self.line1.backgroundColor = self.bgColor
            self.line2.backgroundColor = self.bgColor
            self.line3.backgroundColor = self.bgColor
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == GO_AVATAR_PICKER {
            let picker = segue.destination as! AvatarPickerVC
            picker.bgColor = self.bgColor == nil ? UIColor.lightGray : self.bgColor
        }
    }
    @objc func handleTab() {
        view.endEditing(true)
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}















