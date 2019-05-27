//
//  CameraViewController.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/4/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var isConfigured: Bool = false
    
    var didCapturePhoto: ((UIImage)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Camera"
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapCaptureButton(_:)))
        
        configureCaptureSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isConfigured {
            captureSession.startRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession.stopRunning()
    }
    
    private func configureCaptureSession() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        isConfigured = true
    }
    
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: .video,
                                                                      position: .unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            switch device.position {
            case .front:
                frontCamera = device
            case .back:
                backCamera = device
            default:
                continue
            }
        }
        currentCamera = backCamera
    }
    
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        self.view.addSubview(photoContainer)
        photoContainer.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view)
            make.right.left.equalTo(view)
            make.height.equalTo(120)
        }
        photoContainer.addSubview(buttonCapture)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        downSwipe.direction = .down
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender: )))
        rightSwipe.direction = .right
        view.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        buttonCapture.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(70)
            make.centerX.equalTo(photoContainer)
            make.top.equalTo(photoContainer).offset(8)
        }
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            dismiss(animated: true)
        }
    }
    
    
    private func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    @objc private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func didTapCaptureButton(_ sender: UIBarButtonItem) {
        photoOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    let buttonCapture: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "photo-camera"), for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.layer.borderWidth = 0.4
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didTapCaptureButton(_:)), for: .touchUpInside)
        return button
    }()
    
    let photoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard
            let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData)
            else {
                print("Failed for some reason")
                return
        }
        didCapturePhoto?(image)
    }
}

