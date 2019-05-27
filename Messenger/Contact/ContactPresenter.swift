//
//  ContactPresenter.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/27/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import CoreData



class ContactPresenter {
    public weak var view: ContactView?
    
    let contactRepository = ContactRepository()
    private var filter: Filter = .none
    
    private var contacts: [Contact] = []{
        didSet{
            reloadData()
        }
    }
    
    var reloadData: (() -> ()) = { }
    var didFail: ((_ message: String) -> ()) = { _ in }
    
    func fetchContacts() {
        contacts = contactRepository.fetchContacts(usingFilter: filter)
    }
    
    func numberOfPeople() -> Int {
        return contacts.count
    }
    
    func getContact(atRow row: Int) -> Contact {
        return contacts[row]
    }
    
    func deleteContact(atRow row: Int){
        let name = getContact(atRow: row).name
        do{
            try contactRepository.deleteContact(withName: name)
            fetchContacts()
        }catch{
            didFail("Failed to delete \(name)")
        }
    }
    
    func getContacts(){
        view?.showLoading()
        view?.hideLoading()
        
        contacts.append(Contact(name: "Steve", surname: "Jobs", phone: "879218912812"))
        contacts.append(Contact(name: "Mark", surname: "Zucerberg", phone: "879218912812"))
        contacts.append(Contact(name: "Ilon", surname: "Mask", phone: "879218912812"))
        contacts.append(Contact(name: "John", surname: "Devison", phone: "879218912812"))
        contacts.append(Contact(name: "Michael", surname: "Jackson", phone: "879218912812"))
        
        view?.showContact(contacts: contacts)
    }
}

protocol ContactView: BaseView{
    func showContact(contacts: [Contact])
}
