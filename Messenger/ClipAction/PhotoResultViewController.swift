//
//  PhotoResultViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/4/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit

protocol SendingPhotoDelegate {
    func sendDataToChatViewController(myData: String)
}

class PhotoResultViewController: UIViewController{
    
    // MARK: - Properties
    var heightOfTextContainer = 70
    var bottomConstraint: NSLayoutConstraint?
    let enterMessage = "Enter message"
    var delegate: SendingPhotoDelegate?
    var sendData:((UIImage, String?)->())?
    
    // MARK: - Life Cycle
    init(withImage image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = image
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Result"
        view.backgroundColor = .white
        view.addSubview(textContainer)
        textContainer.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(70)
            make.right.left.equalTo(view)
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(textContainer.snp.top)
            make.right.left.equalTo(view)
        }
        setupTextContainer()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))

        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        
        //UIPanGestureRecognizer
        bottomConstraint = NSLayoutConstraint(item: textContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // MARK: - Button Actions
    @objc func didTap(){
        view.endEditing(true)
    }
    
    @objc func decline(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendPhoto(){
        guard let image = imageView.image else { return }
        let text = textView.text
        sendData?(image, text)
    }
    
    @objc func handleKeyboard(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            heightOfTextContainer = isKeyboardShowing ? 50 : 70
            textView.textColor = isKeyboardShowing ? .black : .lightGray
            
            if isKeyboardShowing && textView.text == enterMessage{
                textView.text = enterMessage
            }else{
                textView.text = ""
            }
            textView.text = isKeyboardShowing ? "" : "Enter message"
            textContainer.snp.updateConstraints { (update) -> Void in
                update.height.equalTo(heightOfTextContainer)
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in })
        }
    }
    
    // MARK: - SetupTextContainer
    func setupTextContainer(){
        textContainer.addSubview(textView)
        textContainer.addSubview(sendButton)
        textContainer.addSubview(retakePhoto)
        textView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(textContainer)
            make.top.equalTo(textContainer).offset(5)
            make.right.equalTo(textContainer).offset(-40)
            make.left.equalTo(textContainer).offset(40)
            make.height.equalTo(40)
        }
        retakePhoto.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(textView)
            make.left.equalTo(5)
            make.height.width.equalTo(30)
        }
        sendButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(textView)
            make.right.equalTo(-5)
            make.height.width.equalTo(30)
        }
    }
    
    // MARK: - Views
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let textView: UITextView = {
        let text = UITextView()
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        text.font = UIFont(name: "verdana", size: 13.0)
        text.backgroundColor = .white
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.4
        return text
    }()
    let retakePhoto: UIButton = {
        var button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setImage(UIImage(named: "left-arrow"), for: .normal)
        button.addTarget(self, action: #selector(decline), for: .touchUpInside)
        return button
    }()
    
    let textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setImage(UIImage(named: "send-button"), for: .normal)
        button.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
        return button
    }()
    
}
