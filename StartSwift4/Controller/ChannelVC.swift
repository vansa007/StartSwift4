//
//  ChannelVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    //visual
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var accountBtn: UIButton!
    @IBOutlet weak var imgAccount: CircleImage!
    @IBOutlet weak var myLoading: UIActivityIndicatorView!
    
    var dataSource:[Channel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        //NotificationCenter.default.addObserver(self, selector: #selector(setAccountName), name: SET_USER_INFO, object: nil)
        SocketService.instance.getChannel { (success) in
            if success {
                self.myTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAccountName()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AuthService.instance.isLoggedIn {
            self.myLoading.stopAnimating()
        }
    }
    
    @objc func setAccountName() {
        var accountName = ""
        if AuthService.instance.isLoggedIn {
            accountName = UserDataService.instance.name.isEmpty ? "Login" : UserDataService.instance.name
            self.imgAccount.image = UIImage(named: UserDataService.instance.avatarName)
            self.imgAccount.backgroundColor = UserDataService.instance.createColor(component: UserDataService.instance.avatarColor)
        }else {
            accountName = "Login"
            self.imgAccount.backgroundColor = UIColor.lightGray
        }
        self.accountBtn.setTitle(accountName, for: .normal)
        self.myTableView.reloadData()
        self.myLoading.stopAnimating()
    }
    
    @IBAction func unWindFromLogin(unWindSeque: UIStoryboardSegue) {}
    
    @IBAction func goLoginAction(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            profile.modalTransitionStyle = .crossDissolve
            self.present(profile, animated: true, completion: nil)
        }else {
            self.performSegue(withIdentifier: GO_LOGIN, sender: nil)
        }
    }
    @IBAction func addChannelAction(_ sender: UIButton) {
        self.myTableView.reloadData()
        let addChannel = AddChannelVC()
        addChannel.modalPresentationStyle = .custom
        addChannel.modalTransitionStyle = .crossDissolve
        self.present(addChannel, animated: true, completion: nil)
    }
}

extension ChannelVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("count: \(MessageService.instance.channels.count)")
        return MessageService.instance.channels.count > 0 ? MessageService.instance.channels.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellchannel", for: indexPath) as! ChannelCC
        cell.avatar.image = #imageLiteral(resourceName: "light4")
        cell.channelName.text = MessageService.instance.channels.count > 0 ? MessageService.instance.channels[indexPath.row].channelTitle : "No channel"
        cell.sms.text = MessageService.instance.channels.count > 0 ? MessageService.instance.channels[indexPath.row].channelDesc : "Please create channel to start chat.."
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MessageService.instance.chSelected = MessageService.instance.channels[indexPath.row]
        self.revealViewController().revealToggle(animated: true)
        NotificationCenter.default.post(name: CH_SELECTED, object: nil)
    }
    
}

class ChannelCC: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var sms: UILabel!
}
