//
//  Friend.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import CoreData

class Friend {
    var name: String?
    var profileImage: String?

    init(){}

    init(withFriend friend: NSManagedObject){
        self.name = (friend.value(forKey: "name") as? String) ?? ""
        self.profileImage = (friend.value(forKey: "profileImage")  as? String) ?? ""
    }
    init(name: String, profileImage:  String){
        self.name = name
        self.profileImage = profileImage
    }
}
