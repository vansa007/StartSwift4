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
    
    let ava = [#imageLiteral(resourceName: "dark1"), #imageLiteral(resourceName: "dark2"), #imageLiteral(resourceName: "dark3"), #imageLiteral(resourceName: "dark4"), #imageLiteral(resourceName: "dark5"), #imageLiteral(resourceName: "dark6"), #imageLiteral(resourceName: "dark7")]
    let dataSource = ["Nem Sothea", "Jayz Walker", "នួន វេយោ", "Voy Rathana", "Ek Choun", "Julie Ma Ma", "Sun Malen"]
    let sms = [
        "I am city ground, please come here hurry up please.",
        "There are now two different segue classes, SWRevealViewControllerSegueSetController and SWRevealViewControllerSeguePushController.",
        "The first one is meant to set the revealViewController with the initial controllers from the story board. The second one is used to push controllers to the front with animation. The former SWRevealViewControllerSegue still works but it has been deprecated.",
        "Dropped support for iOS6 and earlier. This version will only work on iOS7",
        "The method setFrontViewController:animated: does no longer behave as previously. Particularly, it does not perform a full reveal animation. Instead it just replaces the frontViewController at its current position with optional animation.",
        "Use the new pushFrontViewController:animated: method as a replacement for your previous calls to setFrontViewController:animated:.",
        "Added support for animated replacement of child controllers. The methods setRearViewController, setFrontViewController, setRightViewController now all have animated versions. The default animation is a Cross Dissolve effect. "
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAccountName()
    }
    
    func setAccountName() {
        let accountName = AuthService.instance.isLoggedIn ? AuthService.instance.userEmail : "Login"
        self.accountBtn.setTitle(accountName, for: .normal)
    }
    
    @IBAction func unWindFromLogin(unWindSeque: UIStoryboardSegue) {}
    
}

extension ChannelVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellchannel", for: indexPath) as! ChannelCC
        cell.avatar.image = ava[indexPath.row]
        cell.channelName.text = dataSource[indexPath.row]
        cell.sms.text = sms[indexPath.row]
        return cell
    }
    
}

class ChannelCC: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var sms: UILabel!
}
