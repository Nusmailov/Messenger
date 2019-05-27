//
//  PhotoMessageTableViewCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/22/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SnapKit


protocol StartStopAnimatingDelegate: class{
    func didTapStopButton()
    func didTapStartButton()
    func didTapStartVideo()
}

class PhotoMessageTableViewCell: UITableViewCell {
    var centerContraint:Constraint?
    var leadingContraint:Constraint?
    var trailingContraint:Constraint?
    var stateTimer: Bool?
    var stateAnimating: Bool!
    var starter: Bool = false
//    let blurEffect = UIBlurEffect(style: .light)
    lazy var blurView = UIVisualEffectView(effect:  UIBlurEffect(style: .light))
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    var progressBar: ProgressBarView!
    var delegate: StartStopAnimatingDelegate?
    var progressCounter: Float = 0 {
        didSet {
            showProgressInAction()
        }
    }
    
    var radianRotate = CGFloat(Double.pi)/18
    weak var rotateViewTimer: Timer!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(bubbleView)
        stateTimer = true
        stateAnimating = false
        starter = false
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addSubview(imageMessage)
        bubbleView.addSubview(messageLabel)
        bubbleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            centerContraint = make.centerX.equalToSuperview().constraint
            leadingContraint = make.leading.equalToSuperview().offset(10).constraint
            trailingContraint = make.trailing.equalToSuperview().offset(-10).constraint
        }
        centerContraint?.activate()
        imageMessage.isUserInteractionEnabled = true
        imageMessage.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(self.frame.width / 2)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageMessage.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview().offset(-10)
        }
        
        imageMessage.addSubview(blurView)
        blurView.isHidden = true
        blurView.isUserInteractionEnabled = true
        blurView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        progressBar = ProgressBarView(frame: CGRect(x: blurView.frame.width/2 - 25, y: blurView.frame.height/2 - 25, width: 50, height: 50))
        progressBar.isHidden = true
        imageMessage.addSubview(progressBar)
        
        progressBar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    // MARK: Operations
    func setStatus(status: MessageType){
        centerContraint?.deactivate()
        leadingContraint?.deactivate()
        trailingContraint?.deactivate()
        bubbleView.backgroundColor = status.backgroundColor
        messageLabel.textColor = status.textColor
        if status == .inComing{ leadingContraint?.activate() }
        else{ trailingContraint?.activate() }
    }
    
    @objc func rotateView(){
        radianRotate += CGFloat(Double.pi)/90
        radianRotate = radianRotate.truncatingRemainder(dividingBy: 360)
        progressBar.transform = CGAffineTransform(rotationAngle: CGFloat(radianRotate))
    }
    
    func startAnimatingIfNeeded(){
        if !starter {
            starter = true
            imageMessage.addSubview(actionButton)
            actionButton.setImage(UIImage(named: "close"), for: .normal)
            actionButton.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.height.width.equalTo(50)
            }
            
            actionButton.imageView?.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview().offset(15)
                make.right.bottom.equalToSuperview().offset(-15)
            }
            showHideAnimating()
            rotateViewTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateView), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func showHideAnimating(){
        actionButton.isHidden = stateAnimating
        blurView.isHidden = stateAnimating
        progressBar.isHidden = stateAnimating
        stateAnimating = !stateAnimating
    }
    
    @objc func showProgressInAction(){
        if(progressCounter >= 100) {
            progressCounter = 0
            starter = false
            stateTimer = nil
            showHideAnimating()
            if rotateViewTimer != nil {
                rotateViewTimer.invalidate()
            }
        }
        progressBar.progress = progressCounter/100
    }
    
    @objc func actionLoader(){
        if(stateTimer!){
            actionButton.setImage(UIImage(named: "download-icon"), for: .normal)
            delegate?.didTapStopButton()
            progressBar.progress = 0
            radianRotate = 0
            stateTimer = false
        }else if(!stateTimer!){
            actionButton.setImage(UIImage(named: "close"), for: .normal)
            delegate?.didTapStartButton()
            stateTimer = true
        }else{
            actionButton.setImage(UIImage(named: "play-button"), for: .normal)
            delegate?.didTapStartVideo()
        }
        startAnimatingIfNeeded()
    }
    
    //MARK: Verstka
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        button.addTarget(self, action: #selector(actionLoader), for: .touchUpInside)
        return button
    }()
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    var messageLabel: UILabel = {
        var text = UILabel()
        text.font = UIFont.systemFont(ofSize: 16.0)
        text.text = "Some messages are here"
        text.backgroundColor = .clear
        text.numberOfLines = 0
        text.sizeToFit()
        return text
    }()
    var imageMessage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        image.contentMode = .scaleAspectFill
        return image
    }()

}
