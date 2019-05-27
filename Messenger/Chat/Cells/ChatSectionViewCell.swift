//
//  ChatSectionViewCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/5/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SnapKit

class ChatSectionViewCell: UICollectionReusableView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainView)
        addSubview(labelText)
        mainView.snp.makeConstraints { (make)->Void in
            make.left.equalTo(130)
            make.right.equalTo(-130)
            make.height.equalToSuperview()
        }
        labelText.snp.makeConstraints { (make)-> Void in
            make.center.equalTo(mainView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let labelText: UILabel = {
        let text = UILabel()
        text.text = "Today"
        text.textColor = .black
        return text
    }()
}
