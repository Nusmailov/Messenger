//
//  BaseCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/25/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() { }
}
