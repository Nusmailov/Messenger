//
//  PhotoMessageTableViewCell.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/22/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

// MARK: - AnimationProtocol
protocol StartStopAnimatingDelegate: class {
    func didTapStopDownload()
    func didTapStartDownload()
    func didTapStartVideo()
}


enum LoaderProcessType {
    case started
    case stopped
    case startVideo
};

class PhotoMessageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private var stateAnimating: Bool!
    private var isStartedLoader: Bool = false
    lazy var blurView = UIVisualEffectView(effect:  UIBlurEffect(style: .light))
    private var pathCenter: CGPoint{ get { return self.convert(self.center, from:self.superview) } }
    
    public var radianRotate = CGFloat(Double.pi)/18
    weak var rotateViewTimer:Timer!
    public var progressCounter:Float = 0 {
        didSet {
            loaderStateInProgress()
        }
    }
    private let processMaxValue:Float = 100.0
    var loaderProcessType: LoaderProcessType?
    private var centerContraint:Constraint?
    private var leadingContraint:Constraint?
    private var trailingContraint:Constraint?
    public var progressBar:ProgressBarView!
    public var delegate:StartStopAnimatingDelegate?
    // MARK: - Views
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
    // MARK: - Cell Cycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    fileprivate func setupViews() {
        addSubview(bubbleView)
        
        bubbleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            centerContraint = make.centerX.equalToSuperview().constraint
            leadingContraint = make.leading.equalToSuperview().offset(10).constraint
            trailingContraint = make.trailing.equalToSuperview().offset(-10).constraint
        }
        loaderProcessType = .started
        stateAnimating = false
        isStartedLoader = false
        
        bubbleView.isUserInteractionEnabled = true
        bubbleView.addSubview(imageMessage)
        bubbleView.addSubview(messageLabel)
        
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
        blurView.isUserInteractionEnabled = true
        blurView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        progressBar = ProgressBarView(frame: CGRect(x: blurView.frame.width/2 - 25, y: blurView.frame.height/2 - 25, width: 50, height: 50))
        
        imageMessage.addSubview(progressBar)
        progressBar.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        progressBar.isHidden = true
        
        imageMessage.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(50)
        }
        actionButton.setImage(UIImage(named: "close"), for: .normal)
        actionButton.imageView?.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            make.right.bottom.equalToSuperview().offset(-15)
        }
        
    }
    
    // MARK: - Loading Process Action Methods
    func setStatus(status: MessageType) {
        centerContraint?.deactivate()
        leadingContraint?.deactivate()
        trailingContraint?.deactivate()
        bubbleView.backgroundColor = status.backgroundColor
        messageLabel.textColor = status.textColor
        if status == .inComing{ leadingContraint?.activate() }
        else { trailingContraint?.activate() }
    }
    
    @objc func rotateView() {
        radianRotate += CGFloat(Double.pi)/90
        radianRotate = radianRotate.truncatingRemainder(dividingBy: 360)
        progressBar.transform = CGAffineTransform(rotationAngle: CGFloat(radianRotate))
    }
    
    func startAnimatingIfNeeded() {
        if !isStartedLoader {
            isStartedLoader = true
            showHideAnimating()
            loaderProcessType = .started
            rotateViewTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateView), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func showHideAnimating() {
        blurView.isHidden = stateAnimating
        progressBar.isHidden = stateAnimating
        stateAnimating = !stateAnimating
    }
    
    @objc func loaderStateInProgress() {
        if (progressCounter >= processMaxValue) {

            progressCounter = 0
            isStartedLoader = false
            showHideAnimating()
            
            if rotateViewTimer != nil {
                rotateViewTimer.invalidate()
            }
        }
        progressBar.progress = progressCounter/processMaxValue
    }
    
    @objc func actionLoader() {
        switch loaderProcessType {
        case .started?:
            
            actionButton.setImage(UIImage(named: "download-icon"), for: .normal)
            radianRotate = 0
            loaderProcessType = .stopped
            progressBar.progress = 0
            progressBar.isHidden = true
            delegate?.didTapStopDownload()
            
        case .stopped?:
            
            actionButton.setImage(UIImage(named: "close"), for: .normal)
            radianRotate = 0
            progressBar.progress = 0
            progressBar.isHidden = false
            loaderProcessType = .started
            delegate?.didTapStartDownload()
            startAnimatingIfNeeded()
            
        case .startVideo?:
            delegate?.didTapStartVideo()
            
        case .none:
            print("state must be nullable")
        }
    }
    
    public static func videoSnapshot(filePathLocal: NSString) -> UIImage? {
        let vidURL = NSURL(fileURLWithPath: filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch let error as NSError{
            print("Image generation failed with error \(error)")
            return nil
        }
    }
    
    
}
