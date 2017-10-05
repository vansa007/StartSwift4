//
//  AvatarPickerVC.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/4/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarPickerVC: UIViewController {

    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    //variable
    var bgColor: UIColor?
    var avatarArr:[UIImage] = []
    var avatarType = AvatarType.dark
    
    func avatarPictureGenerate() {
        for i in 0..<28 {
            avatarArr.append(UIImage(named: "dark\(i)")!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarPictureGenerate()
    }
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentChangeControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.avatarType = .dark
        }else if sender.selectedSegmentIndex == 1 {
            self.avatarType = .light
        }
        self.myCollection.reloadData()
    }
    
}

extension AvatarPickerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatar_picker_id", for: indexPath) as? ColAvatarPickerCustomCell{
            cell.configureCell(index: indexPath.item, type: avatarType, bgColor: self.bgColor!)
            return cell
        }
        return ColAvatarPickerCustomCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

class ColAvatarPickerCustomCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func configureCell(index: Int, type: AvatarType, bgColor: UIColor) {
        if type == AvatarType.dark {
            img.image = UIImage(named: "dark\(index)")
        }else {
            img.image = UIImage(named: "light\(index)")
            //self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        self.layer.backgroundColor = bgColor.cgColor
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}













