//
//  MessageService.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/6/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    var channels = [Channel]()
    var chSelected = Channel()
    var messageData = [Message]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHENNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.channels.removeAll()
                guard let data = response.data else { return }
                if let json = JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDesc = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDesc: channelDesc, id: id)
                        self.channels.append(channel)
                    }
                    completion(true)
                }
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func getMessageByChannel(chId: String, completion: @escaping CompletionHandler) {
        Alamofire.request(URL_MESSAGE+chId, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                self.messageData.removeAll()
                guard let data = response.data else { return }
                if let json  = JSON(data: data).array {
                    for item in json {
                        let message = item["messageBody"].stringValue
                        let userName = item["userName"].stringValue
                        let channelId = item["channelId"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let id = item["id"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        let sms = Message(message: message, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messageData.append(sms)
                    }
                }
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}

















