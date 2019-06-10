//
//  Friend.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation

class Friend {
    var name: String?
    var profileImage: String?

    init() {}
    
    init(name: String, profileImage:  String) {
        self.name = name
        self.profileImage = profileImage
    }
}
