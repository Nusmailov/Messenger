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
    
    private var filter: Filter = .none
    
    private var contacts: [Contact] = []{
        didSet{
            reloadData()
        }
    }
    
    var reloadData: (() -> ()) = { }
    var didFail: ((_ message: String) -> ()) = { _ in }
    
    func fetchContacts() {
        contacts = ContactRepository.retrieveContacts(usingFilter: filter)
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
            try ContactRepository.deleteContact(withName: name)
            fetchContacts()
        }catch{
            didFail("Failed to delete \(name)")
        }
    }
    
    func getContacts(){
        view?.showLoading()
        view?.hideLoading()
        view?.showContact(contacts: contacts)
    }
}

protocol ContactView: BaseView{
    func showContact(contacts: [Contact])
}
