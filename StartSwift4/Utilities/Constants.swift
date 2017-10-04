//
//  Constants.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//Authentication
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL = "userEmail"

//URL constant
let BASE_URL = "https://letchatwithme.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
