//
//  Message.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import CoreData

enum MessageType: Int {
    case inComing = 0
    case outGoing = 1
    
    var backgroundColor: UIColor {
        switch self {
        case .inComing:
            return UIColor(white: 0.9, alpha: 1)
        case .outGoing:
            return .blue
        }
    }
    var textColor: UIColor {
        switch self {
        case .inComing:
            return .black
        case .outGoing:
            return .white
        }
    }
}

class Message {
    var text: String?
    var date: Date
    var friend: Friend
    var status: MessageType
    var image: UIImage?
    var urlVideo: String?
    
    init(text: String, date: Date, friend: Friend, status: Int){
        self.text = text
        self.date = date
        self.friend = friend
        self.status = MessageType(rawValue: status) ?? .inComing
    }
   
    init(text: String, date: Date, friend: Friend, status: MessageType, image: UIImage){
        self.text = text
        self.date = date
        self.friend = friend
        self.status = status
        self.image = image
    }
    
    init(fromMessage message: NSManagedObject) {
        self.text = (message.value(forKey: "text") as? String) ?? ""
        self.friend = (message.value(forKey: "friend") as? Friend)!
        self.status = (message.value(forKey: "status") as? Int).map { MessageType(rawValue: $0) ?? .inComing }!
        self.urlVideo = (message.value(forKey: "urlVideo" )as? String) ?? ""
        self.date = (message.value(forKey: "date") as? Date)!
    }
    
}
