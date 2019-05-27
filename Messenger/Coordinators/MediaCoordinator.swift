//
//  MediaCoordinator.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/24/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation
import UIKit

enum MediaType{
    case Gallery
    case Camera
}

class MediaCoordinator {
    var navigationController: UINavigationController!
    var didPickMedia:((UIImage, String?)->())?
    
    func start(type: MediaType){
        switch type {
            case .Gallery:
                showGallery()
            case .Camera:
                showCamera()
        }
    }
    
    func showGallery() {
        let vc = PhotoGalleryViewController()
        vc.didTakePhoto = {(image) in
            self.showResultVC(withImage: image)
        }
        navigationController = UINavigationController(rootViewController: vc)
    }
    
    func showCamera() {
        let vc = CameraViewController()
        vc.didCapturePhoto = {(image) in
            self.showResultVC(withImage: image)
        }
        navigationController = UINavigationController(rootViewController: vc)
    }
    
    func showResultVC(withImage image: UIImage) {
        let vc = PhotoResultViewController(withImage: image)
        vc.sendData = { (image, text) in
            self.didPickMedia?(image, text)
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
}
