//
//  UserDataService.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/4/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    func createColor(component: String) -> UIColor {
        let scanner = Scanner(string: component)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        var r, g, b, a : NSString?
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        let defaultColor = UIColor.lightGray
        guard let rUnW = r else { return defaultColor }
        guard let gUnW = g else { return defaultColor }
        guard let bUnW = b else { return defaultColor }
        guard let aUnW = a else { return defaultColor }
        let rCGF = CGFloat(rUnW.doubleValue)
        let gCGF = CGFloat(gUnW.doubleValue)
        let bCGF = CGFloat(bUnW.doubleValue)
        let aCGF = CGFloat(aUnW.doubleValue)
        return UIColor(red: rCGF, green: gCGF, blue: bCGF, alpha: aCGF)
    }
    
}










