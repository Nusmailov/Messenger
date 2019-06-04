//
//  ChatTableViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/22/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD
import SDWebImage
import CoreData
import AVKit
import AVFoundation

class ChatTableViewController: UIViewController {
    //MARK: - Fields
    fileprivate let cellId = "cellId"
    fileprivate let chatCellId = "chatCellId"
    let enterMessage = "Enter message";
    private let kindId = "kind"
    var image = UIImage()
    var messages = [Message]()
    let presenter = MessagePresenter()
    var tableView = UITableView(frame: .zero)
    var heightOfTextContainer = 70
    var bottomConstraint: NSLayoutConstraint?
    var progressProcent = Float()
    var coreMessages: [Message] = []
    var coreFriends: [Friend] = []
    var dbFriend: [DBFriend] = []
    
    var friend: Friend?{
        didSet{
            navigationItem.title = friend?.name
        }
    }
    let downloader = Downloader()
    
    //MARK: - App Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController!.navigationBar.tintColor = UIColor.black;
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.downloader.delegate = self
        setupTableView()
        setupTextContainer()
        keyboardHeight()
        dbFriend = FriendRepository.retrieveDBFriend()
        messages = MessageRepository.retrieveMessages()
    }
    
    // MARK: - Button Actions
    @objc func showActionSheet(){
        let actionSheet = UIAlertController(title: "Photo", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photo = UIAlertAction(title: "Photo & Video Library", style: .default){ action in
            let coordinator = MediaCoordinator()
            coordinator.start(type: .Gallery)
            coordinator.didPickMedia = { (image,text) in
                let mark = Friend()
                mark.name = "Mark Zuckerberg"
                let message = Message(text: text ?? "", date: Date.init(timeIntervalSinceNow: 86400), status: .outGoing, image: UIImage(), dbfriend: DBFriend())
                do{
                    self.messages = [message] + self.messages
                    self.tableView.reloadData()
                    let index = IndexPath(row: 0, section: 0)
                    if let cell = self.tableView.cellForRow(at: index) as? PhotoMessageTableViewCell {
                        cell.startAnimatingIfNeeded()
                    }
                }
                coordinator.navigationController.dismiss(animated: true)
            }
            self.present(coordinator.navigationController, animated: true)
        }
        let camera = UIAlertAction(title: "Camera", style: .default){action in
            let coordinator = MediaCoordinator()
            coordinator.start(type: .Camera)
            coordinator.didPickMedia = { (image, text) in
                let mark = Friend()
                mark.name = "Mark Zuckerberg"
                let message = Message(text: text ?? "", date: Date.init(timeIntervalSinceNow: 86400), status: .outGoing, image: UIImage(), dbfriend: DBFriend())
                do{
                    self.messages = [message] + self.messages
                    self.tableView.reloadData()
                }
                coordinator.navigationController.dismiss(animated: true)
            }
            self.present(coordinator.navigationController, animated: true)
        }
        let addImage = UIAlertAction(title: "Add Image", style: .default) { (action) in
            let mark = Friend()
            mark.name = "Mark Zuckerberg"
            let message = Message(text: self.textView.text ?? "", date: Date.init(timeIntervalSinceNow: 86400), status: .outGoing, image: UIImage(), dbfriend: DBFriend())
            do{
                self.messages = [message] + self.messages
                self.tableView.reloadData()
                self.downloader.download()
            }
        }
        let addVideo = UIAlertAction(title: "Add Video", style: .default) { (action) in
            let message = Message(text: self.textView.text ?? "", date: Date.init(timeIntervalSinceNow: 86400), status: .outGoing, image: UIImage(), dbfriend: DBFriend())
            do{
                self.messages = [message]  + self.messages
                self.tableView.reloadData()
                self.downloader.download()
            }
        }
        
        actionSheet.addAction(cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(addImage)
        actionSheet.addAction(addVideo)
        present(actionSheet, animated: true, completion: nil)
    }
    @objc func addMessage(){
        let mark = Friend()
        mark.name = "Mark Zuckerberg"
        let message = Message(text: textView.text ?? "", date: Date.init(timeIntervalSinceNow: 86400), status: .outGoing, image: UIImage(), dbfriend: DBFriend())
        do{
            messages = [message] + messages
            tableView.reloadData()
            textView.text = ""
        }
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
    //MARK: - SetupViews
    fileprivate func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = .white
        tableView.register(PhotoMessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(ChatViewCell.self, forCellReuseIdentifier: chatCellId)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
    }
    fileprivate func setupTextContainer(){
        view.addSubview(textContainer)
        view.addSubview(tableView)
        textContainer.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.right.left.equalTo(view)
            make.height.equalTo(70)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(textContainer.snp.top)
            make.right.left.equalTo(view)
        }
        textContainer.addSubview(clipButton)
        textContainer.addSubview(textView)
        textContainer.addSubview(sendButton)
        textView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(textContainer).offset(45)
            make.top.equalTo(textContainer).offset(5)
            make.right.equalTo(textContainer).offset(-70)
            make.height.equalTo(40)
        }
        sendButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(textView)
            make.trailing.equalTo(view).offset(-5)
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
        clipButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(8)
            make.height.equalTo(30)
            make.width.equalTo(30)
            make.centerY.equalTo(textView)
        }
        
    }
    fileprivate func keyboardHeight(){
        bottomConstraint = NSLayoutConstraint(item: textContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Views
    let textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let clipButton: UIButton = {
        let  button = UIButton()
        button.setImage(UIImage(named: "clip1"), for: .normal)
        button.setTitle("", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.2
        button.addTarget(self, action: #selector(addMessage), for: .touchUpInside)
        return button
    }()
    let textView: UITextView = {
        let view = UITextView()
        view.text = "Enter message"
        view.textColor = .lightGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.font = UIFont(name: "verdana", size: 13.0)
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.4
        return view
    }()
}

// MARK: -  TableViewDelegate
extension ChatTableViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let image = messages[indexPath.item].image {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PhotoMessageTableViewCell
            cell.imageMessage.image = image
            cell.messageLabel.text = messages[indexPath.item].text
            cell.setStatus(status: messages[indexPath.item].status)
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: chatCellId, for: indexPath) as! ChatViewCell
            cell.messageLabel.text = messages[indexPath.item].text
            cell.setStatus(status: messages[indexPath.item].status)
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
// MARK: - Presenter Realization

extension ChatTableViewController: DownloaderDelegate{
    
    func didFinish(path: String) {
        messages[0].urlVideo = path
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: .init(row: 0, section: 0)) as? PhotoMessageTableViewCell {
                cell.stateTimer = 3
                cell.actionButton.isHidden = false
                do {
                    try MessageRepository.createDBMessage(withText: "This is America", withDate: Date.init(timeIntervalSinceNow: 86400), status: 1, friend: self.dbFriend[0], urlVideo: path)
                }catch{
                    print(error)
                }
                cell.actionButton.setImage(UIImage(named: "play-button"), for: .normal)
            }
        }
    }
    
    func didFinish(image: UIImage) {
        messages[0].image = image
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: .init(row: 0, section: 0)) as? PhotoMessageTableViewCell {
                cell.imageMessage.image = image
                cell.actionButton.isHidden = true
            }
        }
    }
    
    func progress(_ progress: Float) {
        self.progressProcent = progress
        let index = IndexPath(row: 0, section: 0)
        DispatchQueue.main.async {
            if let cell = self.tableView.cellForRow(at: index) as? PhotoMessageTableViewCell {
                cell.startAnimatingIfNeeded()
                cell.progressCounter = self.progressProcent
            }
        }
    }
    
}

// MARK: StartStopAnimatingDelegates
extension ChatTableViewController: StartStopAnimatingDelegate{
    
    func didTapStartVideo() {
        let url = URL(string: messages[0].urlVideo!)
        let player = AVPlayer(url: url!)
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    func didTapStopButton() {
        self.downloader.stopDownloading()
    }
    
    func didTapStartButton() {
        self.downloader.download()
    }
    
}
