//
//  CustomViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let chatVC = ContactListViewController(collectionViewLayout: layout)
        let chatNavController = UINavigationController(rootViewController: chatVC)
        chatNavController.tabBarItem.title = "Recent"
        chatNavController.tabBarItem.image = UIImage(named: "chat")
        
        viewControllers = [chatNavController,createNavBarController(title: "Calls", imageName: "call"), createNavBarController(title: "History", imageName: "history"),createNavBarController(title: "User", imageName: "user")]
    }
    
    private func createNavBarController(title: String, imageName: String) -> UINavigationController {
        let vc = UIViewController()
        let navContoller = UINavigationController(rootViewController: vc)
        navContoller.tabBarItem.image = UIImage(named: imageName)
        navContoller.tabBarItem.title = title
        return navContoller
    }
}
