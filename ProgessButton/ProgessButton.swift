//
//  ProgessButton.swift
//  ProgessButton
//
//  Created by Thanh on 6/9/16.
//  Copyright © 2016 Cao Phuoc Thanh. All rights reserved.
//

import UIKit


class AnyProgessButton: UIControl {
    
    // MARK: Public Properties
    public var textColor: UIColor = UIColor.black {
        didSet {
            self.maskedProgressLabel.textColor = self.textColor
        }
    }
    
    public var maskedColor: UIColor = UIColor.white {
        didSet {
            self.progressLabel.textColor        = self.maskedColor
            self.progressBar.backgroundColor    = self.maskedColor
            self.updateProgress()
            
        }
    }
    
    public var borderColor: UIColor = UIColor.black {
        didSet {
            self.border.borderColor = self.borderColor.cgColor
        }
    }
    
    public var borderWidth: CGFloat = 1 {
        didSet {
            self.border.borderWidth = self.borderWidth
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
            self.layer.masksToBounds = true
            self.border.cornerRadius = self.cornerRadius
            self.border.masksToBounds = true
        }
    }
    
    public var progress: CGFloat = 0 {
        didSet {
            self.updateProgress()
        }
    }
    
    public var font: UIFont = UIFont.boldSystemFont(ofSize: 25) {
        didSet {
            self.maskedProgressLabel.font   = self.font
            self.progressLabel.font         = self.font
        }
    }
    
    // MARK: Pulic Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initComponents()
    }
    
    private func initComponents() {
        
        self.isExclusiveTouch           = true
        self.isUserInteractionEnabled   = true
        self.isMultipleTouchEnabled     = false
        
        
        self.progressBar.backgroundColor        = self.textColor
        self.backgroundColor                    = UIColor.clear
        self.progressLabel.font                 = self.font
        self.progressLabel.textAlignment        = .center
        self.progressLabel.textColor            = self.maskedColor
        self.progressLabel.layer.masksToBounds  = true
        
        self.maskedProgressLabel.font           = self.progressLabel.font
        self.maskedProgressLabel.textAlignment  = self.progressLabel.textAlignment
        self.maskedProgressLabel.textColor      = self.textColor
        self.maskedProgressLabel.clipsToBounds  = true
        
        self.addSubview(self.progressBar)
        self.addSubview(self.progressLabel)
        self.addSubview(self.maskedProgressLabel)
        self.addSubview(self._mask)
        self.addAllConstraints()
    }
    
    // MARK: Private Properties
    private var progressBarWidthConstraint = NSLayoutConstraint()
    private var progressBarMaskWidthConstraint = NSLayoutConstraint()
    
    private var border                  = CALayer()
    private let _mask                   = UIView()
    private let progressBar             = UIView()
    private let progressLabel           = UILabel()
    private let maskedProgressLabel     = UILabel()
    
    // MARK: Private Methods
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.border.removeFromSuperlayer()
        self.border.frame = self.bounds
        self.layer.addSublayer(border)
        self.updateProgress()
    }
    
    private func updateProgress() {
        let percentage = self.progress * 100
        let strProgress = String(format: "%.1f%", percentage)
        self.progressLabel.text = strProgress
        self.maskedProgressLabel.text = strProgress
        self.progressBarWidthConstraint.constant = self.progress * self.bounds.width
        self.progressBarMaskWidthConstraint.constant = self.progressBarWidthConstraint.constant
        self.layoutIfNeeded()
        self.updateMask()
    }
    
    private func addAllConstraints() {
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.progressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.maskedProgressLabel.translatesAutoresizingMaskIntoConstraints = false
        self._mask.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = ["progressBar": self.progressBar, "progressLabel": self.progressLabel, "maskedProgressLabel": self.maskedProgressLabel, "mask": self._mask]
        
        // progressBar constraint
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressBar]", options: [], metrics: nil, views: views))
        self.progressBarWidthConstraint = NSLayoutConstraint(item: self.progressBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 10.0, constant: 0)
        self.addConstraint(self.progressBarWidthConstraint)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progressBar]|", options: [], metrics: nil, views: views))
        
        // progressLabel constraint
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[progressLabel]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[progressLabel]|", options: [], metrics: nil, views: views))
        
        // maskedProgressLabel constraint
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[maskedProgressLabel]|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[maskedProgressLabel]|", options: [], metrics: nil, views: views))
        
        // mask constraint
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mask]", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mask]|", options: [], metrics: nil, views: views))
        
        self.progressBarMaskWidthConstraint = NSLayoutConstraint(item: self._mask, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 10.0, constant: 0)
        self.addConstraint(self.progressBarMaskWidthConstraint)
        
    }
    
    private func updateMask() {
        let maskLayer                       = CAShapeLayer()
        let maskRect                        = CGRect(x: 0, y: 0, width: progressBarMaskWidthConstraint.constant, height: self._mask.bounds.size.height)
        let path                            = CGPath(rect: maskRect, transform: nil)
        maskLayer.path                      = path
        self.maskedProgressLabel.layer.mask = maskLayer;
    }
    
    
    private var touchesBeganPosition: CGFloat?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {  return }
        let position = touch.location(in: self)
        self.touchesBeganPosition = position.x
        self.sendActions(for: .editingDidBegin)
        self.handlePosition(position.x)
    }
    
    private func handlePosition(_ position: CGFloat) {
        if position < 0 {
            self.progress = 0
            self.sendActions(for: .valueChanged)
        } else if position > self.bounds.width {
            self.progress = 1
            self.sendActions(for: .valueChanged)
        } else {
            self.progress = CGFloat(position/self.bounds.width)
            self.sendActions(for: .valueChanged)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchesBeganPosition = self.touchesBeganPosition else { return }
        guard  let touch = touches.first else { return }
        let position = touch.location(in: self)
        self.touchesBeganPosition = (position.x - touchesBeganPosition)
        self.handlePosition(position.x)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sendActions(for: .editingDidEnd)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sendActions(for: .editingDidEnd)
    }
}
