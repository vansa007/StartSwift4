//
//  ChatVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //visual
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var smsTextView: UITextView!
    @IBOutlet weak var bottomSmsConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.settingUpScreen(notification:)), name: CH_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        self.myTableView.rowHeight = UITableViewAutomaticDimension
        self.myTableView.estimatedRowHeight = 250.0
        
        if AuthService.instance.isLoggedIn {
            if let txt = MessageService.instance.chSelected.channelTitle {
                self.headerText.text = txt
            }else {
                self.headerText.text = "Choose channel"
            }
            AuthService.instance.findUserByEmail(email: AuthService.instance.userEmail, completion: { (success) in
                if success {
                    //NotificationCenter.default.post(name: SET_USER_INFO, object: nil)
                    MessageService.instance.findAllChannel(completion: { (success) in})
                }
            })
            
            SocketService.instance.getMessage(completion: { (success) in
                self.myTableView.reloadData()
            })
            
        }else {
            self.headerText.text = "Please login"
        }
    }
    
    @objc func settingUpScreen(notification: Notification) {
        self.headerText.text = MessageService.instance.chSelected.channelTitle
        MessageService.instance.getMessageByChannel(chId: MessageService.instance.chSelected.id) { (success) in
            self.myTableView.reloadData()
            NotificationCenter.default.removeObserver(self, name: CH_SELECTED, object: nil)
        }
    }
    
    @objc func hideKeyboard() {
        //NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        self.bottomSmsConstant.constant = 0.0
    }
    
    @objc func showKeyboard() {
        //NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        self.bottomSmsConstant.constant = 300.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: CH_SELECTED, object: nil)
    }
    @IBAction func sendSmsAction(_ sender: UIButton) {
        //MARK: send message
        if let messageDetail = self.smsTextView.text, !messageDetail.isEmpty {
            SocketService.instance.createMessage(chId: MessageService.instance.chSelected.id, sms: messageDetail, data: UserDataService.instance) { (success) in
                if success {
                    NotificationCenter.default.post(name: CH_SELECTED, object: nil)
                }
            }
        }else {
            let alert = UIAlertController(title: "Note", message: "Check your message again!", preferredStyle: .alert)
            let checkBtn = UIAlertAction(title: "Check", style: .cancel, handler: nil)
            alert.addAction(checkBtn)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ChatVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messageData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "smscell", for: indexPath) as? SMSCell {
            cell.configCell(data: MessageService.instance.messageData[indexPath.row])
            return cell
        }
        return SMSCell()
    }
}

extension ChatVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

class SMSCell: UITableViewCell {
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var sms: UILabel!
    
    func configCell(data: Message) {
        self.avatarImg.image = UIImage(named: data.userAvatar)
        self.avatarImg.backgroundColor = UserDataService.instance.createColor(component: data.userAvatarColor)
        self.userName.text = data.userName
        self.timeStamp.text = data.timeStamp
        self.sms.text = data.message
    }
    
}

















