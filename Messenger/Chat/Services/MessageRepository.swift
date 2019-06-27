//
//  MessageRepository.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/5/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import CoreData
import UIKit

class MessageRepository {
    
    // MARK: - Properties
    private static var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Message Core Data CRUD
    
    static func createDBMessage(withText text: String, withDate date: Date, status: Int, friend: DBFriend, urlVideo: String? = nil, urlImage: String? = nil) throws {
        guard let managedContext = self.managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "DBMessage", in: managedContext)!
        let message = NSManagedObject(entity: entity, insertInto: managedContext)
        
        message.setValue(text, forKeyPath: "text")
        message.setValue(friend, forKeyPath: "friend")
        message.setValue(date, forKeyPath: "date")
        message.setValue(status, forKeyPath: "type")
        message.setValue(urlVideo, forKey: "urlVideo")
        message.setValue(urlImage, forKey: "urlImage")
        
        try managedContext.save()
    }
    
    static func retrieveMessages(usingFilter filter: Filter = .none) -> [Message] {
        guard let managedContext = self.managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBMessage")
        switch filter {
            case .ascendingOrder:
                fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
            case .descendingOrder:
                fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
            case .search(let text):
                fetchRequest.predicate = NSPredicate(format: "text contains[c] %@", text)
            case .none:
                break
        }
        do {
            return try managedContext.fetch(fetchRequest).map { (info) in
                let text = (info.value(forKey: "text") as? String) ?? ""
                let dbfriend = (info.value(forKey: "friend") as? DBFriend)!
                let status = (info.value(forKey: "type") as? Int).map { MessageType(rawValue: $0) ?? .inComing }!
                let urlVideo = (info.value(forKey: "urlVideo" ) as? String) ?? ""
                let urlImage = (info.value(forKey: "urlImage" ) as? String) ?? ""
                let date = (info.value(forKey: "date") as? Date)!
                return Message(text: text, date: date, status: status, dbFriend: dbfriend, urlVideo: urlVideo, urlImage: urlImage)
            }
        } catch {
            return []
        }
    }
    
    static func updateMessage(withText text: String, to newText: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBMessage")
        fetchRequest.predicate = NSPredicate(format: "text = %@", text)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let message = fetchResult.first else { return }
        message.setValue(newText, forKey: "text")
        try managedContext.save()
    }
    
    static func deleteMessage(withText text: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBMessage")
        fetchRequest.predicate = NSPredicate(format: "text = %@", text)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let message = fetchResult.first else { return }
        managedContext.delete(message)
        try managedContext.save()
    }
}
