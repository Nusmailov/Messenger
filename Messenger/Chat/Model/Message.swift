//
//  Message.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var text: String?
    var date: Date
    var image: UIImage?
    var urlVideo: String?
    var urlImage: String?
    //    var friend: Friend
    var dbFriend: DBFriend
    var status: MessageType
    
    init(text: String, date: Date, status: Int, dbFriend: DBFriend) {
        self.text = text
        self.date = date
        self.status = MessageType(rawValue: status) ?? .inComing
        self.dbFriend = dbFriend
    }
   
    init(text: String, date: Date, status: MessageType, image: UIImage, dbFriend: DBFriend) {
        self.text = text
        self.date = date
        self.status = status
        self.image = image
        self.dbFriend = dbFriend
    }
    
    init(text: String, date: Date,status: MessageType, dbFriend: DBFriend, urlVideo: String, urlImage: String) {
        self.text = text
        self.date = date
        self.status = status
        self.dbFriend = dbFriend
        self.urlVideo = urlVideo
        self.urlImage = urlImage
    }
}
