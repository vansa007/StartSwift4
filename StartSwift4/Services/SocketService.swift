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
            if !MessageService.instance.channels.contains(where: { (ch) -> Bool in ch.id == newCh.id }) {
                MessageService.instance.channels.append(newCh)
                completion(true)
            }
        }
    }
}
