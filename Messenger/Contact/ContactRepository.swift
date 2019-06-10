//
//  ContactRepository.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/5/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//


import CoreData
import UIKit

class ContactRepository {
    
    // MARK: - Properties
    private static  var managedContext: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Contact Core Data CRUD
    static func updateContact(withName name: String, to updatedName: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBContact")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let contact = fetchResult.first else { return }
        contact.setValue(updatedName, forKey: "name")
        try managedContext.save()
    }
    
    static func deleteContact(withName name: String) throws {
        guard let managedContext = self.managedContext else { return }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBContact")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        let fetchResult = try managedContext.fetch(fetchRequest)
        guard let person = fetchResult.first else { return }
        managedContext.delete(person)
        try managedContext.save()
    }
    
    static func addContact(withName name: String, surname: String, phone:String) throws {
        guard let managedContext = self.managedContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "DBContact", in: managedContext)!
        let contact = NSManagedObject(entity: entity, insertInto: managedContext)
        
        contact.setValue(name, forKeyPath: "name")
        contact.setValue(surname, forKeyPath: "surname")
        contact.setValue(phone, forKeyPath: "phone")
        
        try managedContext.save()
    }
    
    static func retrieveContacts(usingFilter filter: Filter = .none) -> [Contact] {
        guard let managedContext = self.managedContext else { return [] }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DBContact")
        
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
            return try managedContext.fetch(fetchRequest).map {
                let name = ($0.value(forKey: "name") as? String) ?? "NoName"
                let surname = ($0.value(forKey: "surname") as? String) ?? "NoSurname"
                let phone = ($0.value(forKey: "phone") as? String) ??  "NoPhone"
                return Contact(name: name, surname: surname, phone: phone)
            }
        } catch {
            return []
        }
    }
}
