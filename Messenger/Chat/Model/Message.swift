//
//  Message.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit

enum MessageType {
    case inComing
    case outGoing
    
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

class Message{
    var text: String?
    var date: NSDate?
    var friend: Friend?
    var status: MessageType?
    var image: UIImage?
    var urlVideo: URL?
    
    init(){}
    
    init(text: String, date: NSDate, friend: Friend, status: MessageType){
        self.text = text
        self.date = date
        self.friend = friend
        self.status = status
    }
   
    init(text: String, date: NSDate, friend: Friend, status: MessageType, image: UIImage){
        self.text = text
        self.date = date
        self.friend = friend
        self.status = status
        self.image = image
    }
}
