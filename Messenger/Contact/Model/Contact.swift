//
//  Contact.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/26/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import CoreData


class Contact{
    public var name: String
    public var surname: String
    public var phone: String
    public var imageUrl: String?
    
    init(name: String, surname: String, phone:  String) {
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
    init(fromContact contact: NSManagedObject) {
        self.name = (contact.value(forKey: "name") as? String) ?? "NoName"
        self.surname = (contact.value(forKey: "surname") as? String) ?? "NoSurname"
        self.phone = (contact.value(forKey: "phone") as? String) ??  "NoPhone"
    }
    
}
