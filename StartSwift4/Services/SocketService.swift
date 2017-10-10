//
//  SocketService.swift
//  StartSwift4
//
//  Created by Vansa Pha on 10/6/17.
//  Copyright © 2017 Vansa Pha. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    static let instance = SocketService()
    override init() {
        super.init()
    }
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    func establishConnection() {
        socket.connect()
    }
    func closeConnection() {
        socket.disconnect()
    }
    func addChannel(name: String, desc: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", name, desc)
        completion(true)
    }
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let chName = dataArray[0] as? String else { return }
            guard let chDesc = dataArray[1] as? String else { return }
            guard let chId = dataArray[2] as? String else { return }
            let newCh = Channel(channelTitle: chName, channelDesc: chDesc, id: chId)
            
            var isExist:Bool = false
            for ch in MessageService.instance.channels {
                if ch.id == newCh.id {
                    isExist = true
                }
            }
            if !isExist {
                MessageService.instance.channels.append(newCh)
            }
            completion(true)
        }
    }
    func createMessage(chId: String, sms: String, data: UserDataService, completion: @escaping CompletionHandler) {
        socket.emit("newMessage", sms, data.id, chId, data.name, data.avatarName, data.avatarColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (arr,ack) in
            guard let smsBody = arr[0] as? String else { return }
            guard let userId = arr[1] as? String else { return }
            guard let chId = arr[2] as? String else { return }
            guard let userName = arr[3] as? String else { return }
            guard let userAvatar = arr[4] as? String else { return }
            guard let userAvatarColor = arr[5] as? String else { return }
            guard let smsId = arr[6] as? String else { return }
            guard let timeStamp = arr[7] as? String else { return }
            let message = Message(message: smsBody, userName: userName, channelId: chId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: smsId, timeStamp: timeStamp)
            var isExist:Bool = false
            for sms in MessageService.instance.messageData {
                if sms.id == message.id {
                    isExist = true
                }
            }
            if !isExist && chId == MessageService.instance.chSelected.id {
                MessageService.instance.messageData.append(message)
            }
            completion(true)
        }
    }
    
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (dataArr, ack) in
            guard let typingUsers = dataArr[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
    
}











