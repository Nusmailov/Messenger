//
//  ViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/25/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import CoreData



class ContactListViewController: UICollectionViewController {
    fileprivate var cellid = "cellId"
    var contacts = [Contact]()
    let contactPresenter = ContactPresenter()
    var people: [NSManagedObject] = []
    var photoService: PhotoService?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        fetchPeople()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        contactPresenter.view = self
        contactPresenter.getContacts()
        
        
        
        navigationItem.title = "Chats"
        collectionView?.register(ContactViewCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
    }
    
    private func saveContacts(contact: Contact){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DBContact", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(contact.name, forKeyPath: "name")
        person.setValue(contact.surname, forKey: "surname")
        person.setValue(contact.phone, forKey: "phone")
        
        do {
            try managedContext.save()
            people.append(person)
        }
        catch let error {
            print("Could not save. Due to: \(error.localizedDescription)")
        }
    }
    private func fetchPeople() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchResult = NSFetchRequest<NSManagedObject>(entityName: "DBContact")
        do {
            people = try managedContext.fetch(fetchResult)
        }
        catch let error {
            print("Could not fetch. Due to: \(error.localizedDescription)")
        }
    }
    
}

extension ContactListViewController: ContactView{
    func showLoading() {
        SVProgressHUD.show()
    }
    func showContact(contacts: [Contact]) {
        self.contacts = contacts
        collectionView.reloadData()
    }
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
    func showError(errorMessage: String) {
        print(errorMessage)
    }
}

extension ContactListViewController: UICollectionViewDelegateFlowLayout{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ContactViewCell
        let name = people[indexPath.item].value(forKey: "name") as! String
        let surname = people[indexPath.item].value(forKeyPath: "surname") as! String
        cell.nameLabel.text = "\(String(describing: name)) \(String(describing: surname))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/9)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = ChatTableViewController()
        let name = people[indexPath.item].value(forKey: "name") as! String
        let surname = people[indexPath.item].value(forKeyPath: "surname") as! String
        vc.navigationItem.title = "\(String(describing: name)) \(String(describing: surname))"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

