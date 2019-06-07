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
    
    // MARK: - Properties
    fileprivate var cellid = "cellId"
    var contacts = [Contact]()
    let contactPresenter = ContactPresenter()
    var people: [Contact] = []
    var photoService: PhotoService?
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        contactPresenter.view = self
        contactPresenter.getContacts()
        navigationItem.title = "Chats"
        collectionView?.register(ContactViewCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        people = ContactRepository.retrieveContacts()
    }
}

// MARK: - ContactView Extension Views
extension ContactListViewController: ContactView {
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

// MARK: - CollectionView Delegate Methods
extension ContactListViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ContactViewCell
        let name = people[indexPath.item].name
        let surname = people[indexPath.item].surname
        cell.nameLabel.text = "\(String(describing: name)) \(String(describing: surname))"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/9)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = ChatTableViewController()
        let name = people[indexPath.item].name
        let surname = people[indexPath.item].surname
        vc.navigationItem.title = "\(String(describing: name)) \(String(describing: surname))"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

