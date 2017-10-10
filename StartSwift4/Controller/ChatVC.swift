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
    @IBOutlet weak var smsTextView: UITextField!
    @IBOutlet weak var bottomSmsConstant: NSLayoutConstraint!
    @IBOutlet weak var smsG: UIView!
    @IBOutlet weak var typingLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.settingUpScreen(notification:)), name: CH_SELECTED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setUserInfo(_:)), name: SET_USER_INFO, object: nil)
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
                    MessageService.instance.findAllChannel(completion: { (success) in})
                }
            })
            
            SocketService.instance.getMessage(completion: { (success) in
                self.myTableView.reloadData()
                if MessageService.instance.messageData.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messageData.count - 1, section: 0)
                    self.myTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
                }
            })
            
            //type user
            SocketService.instance.getTypingUsers { (typingUsers) in
                guard let chID = MessageService.instance.chSelected.id else { return }
                var names = ""
                var numberOfTypes = 0
                for (typingUser, channel) in typingUsers {
                    if typingUser != UserDataService.instance.name && channel == chID {
                        if names == "" {
                            names = typingUser
                        }else {
                            names = "\(names), \(typingUser)"
                        }
                        numberOfTypes += 1
                    }
                }
                if numberOfTypes > 0 {
                    var verb = "is"
                    if numberOfTypes > 1 {
                        verb = "are"
                    }
                    self.typingLb.text = "\(names) \(verb) typing a message"
                }else {
                    self.typingLb.text = ""
                }
            }
            
        }else {
            self.headerText.text = "Please login"
        }
    }
    
    @objc func setUserInfo(_ notification: Notification) {
        AuthService.instance.findUserByEmail(email: AuthService.instance.userEmail, completion: { (success) in
            if success {
                MessageService.instance.findAllChannel(completion: { (success) in})
            }
        })
    }
    
    @objc func settingUpScreen(notification: Notification) {
        self.headerText.text = MessageService.instance.chSelected.channelTitle
        MessageService.instance.getMessageByChannel(chId: MessageService.instance.chSelected.id) { (success) in
            self.smsG.isHidden = false
            self.myTableView.reloadData()
            if MessageService.instance.messageData.count > 0 {
                let endIndex = IndexPath(row: MessageService.instance.messageData.count - 1, section: 0)
                self.myTableView.scrollToRow(at: endIndex, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func hideKeyboard(_ noti: Notification) {
        self.bottomSmsConstant.constant = 0.0
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            
        })
    }
    
    @objc func showKeyboard(_ noti: Notification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomSmsConstant.constant = keyboardHeight
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.3, animations: {
                
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func sendSmsAction(_ sender: UIButton) {
        //MARK: send message
        if let messageDetail = self.smsTextView.text, !messageDetail.isEmpty {
            SocketService.instance.createMessage(chId: MessageService.instance.chSelected.id, sms: messageDetail, data: UserDataService.instance) { (success) in
                if success {
                    NotificationCenter.default.post(name: CH_SELECTED, object: nil)
                    self.view.endEditing(true)
                    self.smsTextView.text = ""
                    guard let chId = MessageService.instance.chSelected.id else { return }
                    self.isTyping = false
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, chId)
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
    
    var isTyping: Bool = false
    @IBAction func typingAction(_ sender: UITextField) {
        guard let chId = MessageService.instance.chSelected.id else { return }
        if self.smsTextView.text == "" {
            isTyping = false
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, chId)
        }else {
            if !isTyping {
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, chId)
            }
            isTyping = true
        }
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

extension ChatVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        self.timeStamp.text = ""
        self.sms.text = data.message
        
        guard var isoDate = data.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        if let finalDate = chatDate {
            let fDate = newFormatter.string(from: finalDate)
            self.timeStamp.text = fDate
        }
    }
    
}

















