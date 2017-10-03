//
//  AuthService.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    var isLoggedIn: Bool {
        get { return defaults.bool(forKey: LOGGED_IN_KEY) }
        set { defaults.set(newValue, forKey: LOGGED_IN_KEY) }
    }
    var authToken: String {
        get { return defaults.value(forKey: TOKEN_KEY) as! String }
        set { defaults.set(newValue, forKey: TOKEN_KEY) }
    }
    var userEmail: String {
        get { return defaults.value(forKey: USER_EMAIL) as! String }
        set { defaults.set(newValue, forKey: USER_EMAIL) }
    }
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        //TODO: tomorrow video 063, 20:54
    }
}
