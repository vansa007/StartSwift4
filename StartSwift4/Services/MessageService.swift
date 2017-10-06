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
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHENNEL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                //self.channels.removeAll()
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
}
