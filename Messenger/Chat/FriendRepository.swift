//
//  FriendRepository.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/5/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import CoreData
import UIKit

class FriendRepository {
    
    private static var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    static func updateFriend(withName name: String, to newName: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBFriend")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let message = fetchResult.first else { return }
        message.setValue(newName, forKey: "name")
        try managedContext.save()
    }
    
    static func deleteFriend(withName name: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBFriend")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let friend = fetchResult.first else { return }
        managedContext.delete(friend)
        try managedContext.save()
    }
    
    static func createFriend(withName name: String, withProfileImage profileImage: String) throws {
        guard let managedContext = self.managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "DBFriend", in: managedContext)!
        let friend = NSManagedObject(entity: entity, insertInto: managedContext)
        friend.setValue(name, forKeyPath: "name")
        friend.setValue(profileImage, forKeyPath: "profileImage")
        try managedContext.save()
    }
    
    static func retrieveFriends(usingFilter filter: Filter = .none) -> [Friend]{
        guard let managedContext = self.managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBFriend")
        switch filter {
        case .ascendingOrder:
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        case .descendingOrder:
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        case .search(let text):
            fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", text)
        case .none:
            break
        }
        do {
            return try managedContext.fetch(fetchRequest).map { Friend(withFriend: $0) }
        }
        catch{
            return []
        }
    }
    static func retrieveDBFriend(usingFilter filter: Filter = .none) -> [DBFriend]{
        guard let managedContext = self.managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBFriend")
        switch filter {
        case .ascendingOrder:
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: true)]
        case .descendingOrder:
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "name", ascending: false)]
        case .search(let text):
            fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", text)
        case .none:
            break
        }
        do {
            return try managedContext.fetch(fetchRequest) as! [DBFriend]
        }
        catch{
            return []
        }
    }
}
