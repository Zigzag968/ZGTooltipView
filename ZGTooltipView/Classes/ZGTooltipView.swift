//
//  ZGTooltipView.swift
//  ZGTooltipView
//
//  Created by Alexandre Guibert on 22/05/2016.
//  Copyright © 2016 Zigzag. All rights reserved.
//

import UIKit

private var tooltipTapGestureKey: UInt8 = 0
private var tooltipViewKey: UInt8 = 0

public extension UIView {
    
    public var tooltipTapGesture: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &tooltipTapGestureKey) as? UITapGestureRecognizer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tooltipTapGestureKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var tooltipView: ZGTooltipView? {
        get {
            return objc_getAssociatedObject(self, &tooltipViewKey) as? ZGTooltipView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tooltipViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func setTooltip(_ tooltipView:ZGTooltipView) {
        self.tooltipView = tooltipView
        
        tooltipTapGesture = UITapGestureRecognizer(target: self, action: #selector(UIView.tooltipGestureHandler(_:)))
        self.addGestureRecognizer(tooltipTapGesture!)
    }
    
    public func removeTooltip() {
        if let gesture = tooltipTapGesture {
            self.removeGestureRecognizer(gesture)
        }
        
        tooltipView?.dismiss(remove:true)
    }
    
    public func showTooltip() {
        if tooltipView?.isVisible == false {
            tooltipView?.displayInView(self)
        }
    }
    
    public func dismissTooltip(remove:Bool = false) {
        tooltipView?.dismiss(remove:remove)
    }
    
    @objc fileprivate func tooltipGestureHandler(_ gesture:UIGestureRecognizer) {
        
        if let tooltipView = tooltipView {
            tooltipView.isVisible ? dismissTooltip(remove:false) : showTooltip()
        }
    }
    
}

open class ZGTooltipView: UIView {
    
    static let triangleMargin : CGFloat = 10
    
    open var animationEnable = true
    open override var backgroundColor: UIColor? {
        didSet {
            triangleShapeLayer?.fillColor = backgroundColor?.cgColor
        }
    }
    
    fileprivate var isVisible = false
    fileprivate var contentView : UIView!
    fileprivate var direction : Direction = .left
    fileprivate var triangleShapeLayer : CAShapeLayer!
    
    @objc public enum Direction : Int {
        case left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight
    }
    
     convenience public init(direction:Direction, text:String) {
        self.init(frame:CGRect.zero)
        self.direction = direction
        
        setup()

        contentView = createLabelWithText(text)
    }
    
     convenience public init(direction:Direction, customView:UIView) {
        self.init(frame:CGRect.zero)
        self.direction = direction
        
        setup()
        
        contentView = customView
    }
    
    fileprivate func setup() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
    }
    
    open func createLabelWithText(_ text:String) -> UILabel {
        
        let label = UILabel(frame:CGRect.zero)
        label.textColor = UIColor.white
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width * 0.7))
        
        return label
    }
    
    fileprivate func directionIsVertical() -> Bool {
        
        return (direction == .top || direction == .topRight || direction == .topLeft || direction == .bottom || direction == .bottomRight || direction == .bottomLeft)
    }
    
    fileprivate func createTriangleShapeLayer() -> CAShapeLayer {
        
        let trianglePath = UIBezierPath()
        
        switch self.direction {
        case .left:
            trianglePath.move(to: CGPoint(x: 0, y: 12))
            trianglePath.addLine(to: CGPoint(x: 7, y: 6))
            trianglePath.addLine(to: CGPoint(x: 0, y: 0))
            trianglePath.addLine(to: CGPoint(x: 0, y: 12))
            break
            
        case .right:
            trianglePath.move(to: CGPoint(x: 7, y: 12))
            trianglePath.addLine(to: CGPoint(x: 0, y: 6))
            trianglePath.addLine(to: CGPoint(x: 7, y: 0))
            trianglePath.addLine(to: CGPoint(x: 7, y: 12))
            break
            
        case .bottom, .bottomRight, .bottomLeft:
            trianglePath.move(to: CGPoint(x: 0, y: 7))
            trianglePath.addLine(to: CGPoint(x: 12, y: 7))
            trianglePath.addLine(to: CGPoint(x: 6, y: 0))
            trianglePath.addLine(to: CGPoint(x: 0, y: 7))
            break
            
        case .top, .topRight, .topLeft:
            trianglePath.move(to: CGPoint(x: 0, y: 0))
            trianglePath.addLine(to: CGPoint(x: 12, y: 0))
            trianglePath.addLine(to: CGPoint(x: 6, y: 7))
            trianglePath.addLine(to: CGPoint(x: 0, y: 0))
            break
        }
        
        trianglePath.close()
        
        let triangleShapeLayer = CAShapeLayer()
        triangleShapeLayer.bounds = trianglePath.bounds
        triangleShapeLayer.path = trianglePath.cgPath
        triangleShapeLayer.fillColor = self.backgroundColor!.cgColor
        
        return triangleShapeLayer
    }
    
    
    fileprivate func displayInView(_ superview:UIView) {
        
        superview.addSubview(self)
        
        self.layoutMargins = UIEdgeInsetsMake(8, 13, 8, 13)
        self.layer.cornerRadius = 4
        
        switch self.direction {
        case .left:
            self.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
            break
        case .right:
            self.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            break
        case .bottom:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            break
        case .top:
            self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            break
        case .topLeft:
            self.layer.anchorPoint = CGPoint(x: 0, y: 1)
            break
        case .topRight:
            self.layer.anchorPoint = CGPoint(x: 1, y: 1)
            break
        case .bottomLeft:
            self.layer.anchorPoint = CGPoint(x: 0, y: 0)
            break
        case .bottomRight:
            self.layer.anchorPoint = CGPoint(x: 1, y: 0)
            break
        }
        
        triangleShapeLayer?.removeFromSuperlayer()
        
        triangleShapeLayer = createTriangleShapeLayer()
        self.layer.addSublayer(triangleShapeLayer)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        let constraintsAttrs = [
            NSLayoutAttribute.top:NSLayoutAttribute.topMargin,
            NSLayoutAttribute.right:NSLayoutAttribute.rightMargin,
            NSLayoutAttribute.bottom:NSLayoutAttribute.bottomMargin,
            NSLayoutAttribute.left:NSLayoutAttribute.leftMargin
        ]
        
        for (fromAttr, toAttr) in constraintsAttrs {
            self.addConstraint(NSLayoutConstraint(item: contentView, attribute: fromAttr, relatedBy: NSLayoutRelation.equal, toItem:self, attribute: toAttr, multiplier: 1, constant: 0))
        }
        
        let triangleSpacing : CGFloat = self.direction == .bottom || self.direction == .bottomRight || self.direction == .bottomLeft || self.direction == .top || self.direction == .topLeft || self.direction == .topRight ? (triangleShapeLayer.bounds.height/2 + 5)  : (triangleShapeLayer.bounds.width/2 + 5)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        switch self.direction {
            
        case .bottom, .bottomLeft, .bottomRight:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant:  triangleSpacing - (self.bounds.height / 2) ))
            break
            
        case .top, .topRight, .topLeft:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant:  (triangleSpacing - (self.bounds.height / 2)) * -1))
            break
            
        case .left, .right:
            superview.addConstraint(NSLayoutConstraint(item: superview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant:  0))
            break
        }
        
        switch self.direction {
        case .left:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1, constant: (triangleSpacing - (self.bounds.width / 2)) * -1))
            break
        case .bottomRight, .topRight:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant:  ((self.bounds.width / 2)) * -1))
            break
        case .bottomLeft, .topLeft:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant:  ((self.bounds.width / 2))))
            break
        case .right:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1, constant:  triangleSpacing - (self.bounds.width / 2) ))
            break
        case .top, .bottom:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant:  0))
            break
        }
        
        if (animationEnable) {
            
            self.layer.transform = CATransform3DMakeScale(0, 0, 1)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
                
                self.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
                }, completion: { (finished) in
                    self.isVisible = finished
            })
            
        } else {
            isVisible = true
        }
    }
    
    func dismiss(remove:Bool) {
        if (animationEnable) {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .allowUserInteraction, animations: {
                
                self.layer.transform = CATransform3DMakeScale(0, 0, 1)
                
                }, completion: { (finished) in
                    
                    DispatchQueue.main.async(execute: {
                        if (remove) { self.removeFromSuperview() }
                    })
                    self.isVisible = !finished
                    
            })
            
            
        } else {
            if (remove) { self.removeFromSuperview() }
            isVisible = false
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let triangleBounds = triangleShapeLayer.bounds
        
        switch self.direction {
        case .left:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width, y: self.bounds.height/2)
            break
        case .right:
            triangleShapeLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
            triangleShapeLayer.position = CGPoint(x: 0, y: self.bounds.height/2)
            break
        case .bottom:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width/2, y: 0)
            break
        case .top:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height)
            break
        case .topLeft:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: ZGTooltipView.triangleMargin, y: self.bounds.height)
            break
        case .topRight:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width - ZGTooltipView.triangleMargin, y: self.bounds.height)
            break
        case .bottomLeft:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: ZGTooltipView.triangleMargin, y: 0)
            break
        case .bottomRight:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width - ZGTooltipView.triangleMargin, y: 0)
            
            break
        }
        
        triangleShapeLayer.bounds = triangleBounds
    }
    
}
