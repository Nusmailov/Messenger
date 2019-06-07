//
//  PhotoGalleryViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/4/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import Photos

class PhotoGalleryViewController: UIViewController {
    var assets: [PHAsset] = []
    var didTakePhoto: ((UIImage)->())?
    
    lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gallery"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        view.addSubview(photosCollectionView)
        photosCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        fetchImages()
    }
    
    // MARK: - Methods
    @objc private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    func fetchImages() {
        DispatchQueue.global(qos: .background).async { [unowned self] in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat
            requestOptions.isNetworkAccessAllowed = false

            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            if fetchResult.count > 0 {
                for i in 0 ..< fetchResult.count {
                    let asset = fetchResult.object(at: i) as PHAsset
                    self.assets.append(asset)
                }
            } else {
                print("There are no images")
            }
            
            DispatchQueue.main.async {
                self.photosCollectionView.reloadData()
            }
        }
        print(assets)
    }
}

// MARK: - CollectionView Delegate methods
extension PhotoGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let asset = assets[indexPath.row]
        asset.getImage(ofSize: CGSize.init(width: 200, height: 200)) { [weak cell] (image) in
            cell?.setImage(image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = assets[indexPath.row]
        asset.getImage(ofSize: PHImageManagerMaximumSize) { [weak self] (image) in
            self?.didTakePhoto!(image)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width/4 - 1, height: width/4 - 1)
    }
}

extension PHAsset {
    func getImage(ofSize size: CGSize, completion: @escaping (UIImage) -> ()) {
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            completion(image!)
        })
    }
}
