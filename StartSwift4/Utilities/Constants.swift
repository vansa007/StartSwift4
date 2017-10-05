//
//  Constants.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/3/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//segue
let GO_HOME = "goto_home"
let GO_HOME_LOGGED = "goto_home_after_logged"
let GO_AVATAR_PICKER = "goto_avatar_picker"
let GO_LOGIN = "goto_login"
let GMAIL_STORYBOARD = "Gmail"
let LOGIN_STORYBOARD = "login_storyboard"

//Authentication
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL = "userEmail"
let USER_NAME = "userName"

//URL constant
let BASE_URL = "https://letchatwithme.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_FIND_BY_EMAiL = "\(BASE_URL)user/byEmail/"

//header
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
