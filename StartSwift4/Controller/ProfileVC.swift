//
//  ProfileVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/5/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var imgAccount: CircleImage!
    @IBOutlet weak var nameAccount: UILabel!
    @IBOutlet weak var emailAccount: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loginLink: RoundedButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeAction(_:)))
        self.bgView.addGestureRecognizer(tap)
        
        //render
        self.configInfo()
    }
    
    func configInfo() {
        let stateColor = UserDataService.instance.createColor(component: UserDataService.instance.avatarColor)
        self.nameAccount.text = UserDataService.instance.name
        self.emailAccount.text = UserDataService.instance.email
        self.imgAccount.image = UIImage(named: UserDataService.instance.avatarName)
        self.imgAccount.backgroundColor = stateColor
        self.nameAccount.textColor = stateColor
        self.emailAccount.textColor = stateColor
        self.loginLink.backgroundColor = stateColor
    }
    
    //MARK: event handler
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: RoundedButton) {
        let login = UIStoryboard(name: GMAIL_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: LOGIN_STORYBOARD) as! LoginVC
        self.present(login, animated: true) {
            login.closeLink.isHidden = true
            UserDataService.instance.logoutUser()
        }
    }
}
