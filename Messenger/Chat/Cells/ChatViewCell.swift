//
//  ChatViewCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/27/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SnapKit

class ChatViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var centerContraint:Constraint?
    private var leadingContraint:Constraint?
    private var trailingContraint:Constraint?
    
    // MARK: - File Views
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let messageLabel: UILabel = {
        var text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16.0)
        text.text = "Some messages are here"
        text.backgroundColor = .clear
        text.numberOfLines = 0
        text.sizeToFit()
        return text
    }()
    
    // MARK: - TableViewCell lifecycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(self.frame.width * 0.75)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            centerContraint = make.centerX.equalToSuperview().constraint
            leadingContraint = make.leading.equalToSuperview().offset(10).constraint
            trailingContraint = make.trailing.equalToSuperview().offset(-10).constraint
        }
        centerContraint?.activate()
        messageLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        centerContraint?.activate()
    }
    
    func setSize(_ size: CGSize) {
        bubbleView.snp.updateConstraints { (update) in
            update.height.equalTo(size.height)
            update.width.equalTo(size.width)
        }
    }
    
    func setStatus(status: MessageType) {
        centerContraint?.deactivate()
        leadingContraint?.deactivate()
        trailingContraint?.deactivate()
        
        bubbleView.backgroundColor = status.backgroundColor
        messageLabel.textColor = status.textColor
        if status == .inComing {
            leadingContraint?.activate()
        }
        else {
            trailingContraint?.activate()
        }
    }
}
