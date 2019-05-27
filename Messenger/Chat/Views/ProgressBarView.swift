//
//  ProgressBarView.swift
//  Messenger
//
//  Created by Nurzhigit Smailov on 4/29/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {
   
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    
    var progress: Float = 0 {
        willSet(newValue) {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        self.simpleShape()
        isUserInteractionEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    func simpleShape() {
        bgPath = UIBezierPath(arcCenter: self.center, radius: 25, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi + CGFloat.pi/2, clockwise: true)
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 7
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 7
        progressLayer.fillColor = nil
        progressLayer.strokeColor = #colorLiteral(red: 0.05098039216, green: 0.7058823529, blue: 0.768627451, alpha: 1)
        progressLayer.strokeEnd = 0.0
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.layer.insertSublayer(progressLayer, at: 1)
    }
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(actionLoader), for: .touchUpInside)
        return button
    }()
    
    @objc func actionLoader(){
        actionButton.setImage(UIImage(named: "dowload-icon"), for: .normal)
        actionButton.imageView?.snp.updateConstraints({ (update) in
            update.left.right.top.bottom.equalToSuperview()
        })
    }
}