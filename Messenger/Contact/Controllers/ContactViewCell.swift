//
//  ContactViewCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 3/25/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class ContactViewCell: BaseCell {
    // MARK: - Properties
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : .white
            nameLabel.textColor = isHighlighted ? .white : .black
            timeLabel.textColor = isHighlighted ? .white : .black
            messageLabel.textColor = isHighlighted ? .white : .darkGray
        }
    }
    
    // MARK: - Cell Setup View Methods
    override func setupViews() {
        backgroundColor = .white
        addSubview(profileImage)
        addSubview(dividerLine)
        setupContainerView()
        
        profileImage.image = UIImage(named: "stevejobs")
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        dividerLine.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintWithFormat(format: "H:|-12-[v0(68)]", views: profileImage)
        addConstraintWithFormat(format: "V:[v0(68)]", views: profileImage)
        addConstraints([NSLayoutConstraint(item: profileImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
        
        addConstraintWithFormat(format: "H:|-82-[v0]|", views: dividerLine)
        addConstraintWithFormat(format: "V:[v0(1)]|", views: dividerLine)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        addConstraintWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintWithFormat(format: "V:[v0(60)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        
        containerView.addConstraintWithFormat(format: "H:|[v0][v1(120)]|", views: nameLabel, timeLabel)
        containerView.addConstraintWithFormat(format: "V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        containerView.addConstraintWithFormat(format: "H:|[v0]-12-|", views: messageLabel)
        containerView.addConstraintWithFormat(format: "V:|[v0(20)]", views: timeLabel)
    }
    
    // MARK: - Views
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds =  true
        return imageView
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Steve Jobs"
        label.font = label.font.withSize(18)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:24 pm"
        label.textAlignment = .right
        label.font = label.font.withSize(16)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Message text and something long text"
        label.font = label.font.withSize(14)
        label.textColor = .darkGray
        return label
    }()
}

extension UIView{
    func addConstraintWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, metrics: nil, views: viewsDictionary))
    }
}
