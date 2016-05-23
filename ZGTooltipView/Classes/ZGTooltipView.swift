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
    
    private var tooltipTapGesture: UITapGestureRecognizer? {
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
    
    public func setTooltip(tooltipView:ZGTooltipView) {
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
    
    public func dismissTooltip(remove remove:Bool = false) {
        tooltipView?.dismiss(remove:remove)
    }
    
    @objc private func tooltipGestureHandler(gesture:UIGestureRecognizer) {
        
        if let tooltipView = tooltipView {
            tooltipView.isVisible ? dismissTooltip(remove:false) : showTooltip()
        }
    }
    
}

public class ZGTooltipView: UIView {
    
    static let triangleMargin : CGFloat = 10
    
    public var animationEnable = true
    public override var backgroundColor: UIColor? {
        didSet {
            triangleShapeLayer.fillColor = backgroundColor?.CGColor
        }
    }
    
    private var isVisible = false
    private var contentView : UIView!
    private var direction : Direction = .Left
    private var triangleShapeLayer : CAShapeLayer!
    
    @objc public enum Direction : Int {
        case Left, Right, Top, Bottom, TopLeft, TopRight, BottomLeft, BottomRight
    }
    
     convenience public init(direction:Direction, text:String) {
        self.init(frame:CGRectZero)
        self.direction = direction
        
        setup()

        contentView = createLabelWithText(text)
    }
    
     convenience public init(direction:Direction, customView:UIView) {
        self.init(frame:CGRectZero)
        self.direction = direction
        
        setup()
        
        contentView = customView
    }
    
    private func setup() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.8)
    }
    
    public func createLabelWithText(text:String) -> UILabel {
        
        let label = UILabel(frame:CGRectZero)
        label.textColor = UIColor.whiteColor()
        label.text = text
        label.font = UIFont.systemFontOfSize(13)
        label.numberOfLines = 0
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: UIScreen.mainScreen().bounds.width * 0.7))
        
        return label
    }
    
    private func directionIsVertical() -> Bool {
        
        return (direction == .Top || direction == .TopRight || direction == .TopLeft || direction == .Bottom || direction == .BottomRight || direction == .BottomLeft)
    }
    
    private func createTriangleShapeLayer() -> CAShapeLayer {
        
        let trianglePath = UIBezierPath()
        
        switch self.direction {
        case .Left:
            trianglePath.moveToPoint(CGPointMake(0, 12))
            trianglePath.addLineToPoint(CGPointMake(7, 6))
            trianglePath.addLineToPoint(CGPointMake(0, 0))
            trianglePath.addLineToPoint(CGPointMake(0, 12))
            break
            
        case .Right:
            trianglePath.moveToPoint(CGPointMake(7, 12))
            trianglePath.addLineToPoint(CGPointMake(0, 6))
            trianglePath.addLineToPoint(CGPointMake(7, 0))
            trianglePath.addLineToPoint(CGPointMake(7, 12))
            break
            
        case .Bottom, .BottomRight, .BottomLeft:
            trianglePath.moveToPoint(CGPointMake(0, 7))
            trianglePath.addLineToPoint(CGPointMake(12, 7))
            trianglePath.addLineToPoint(CGPointMake(6, 0))
            trianglePath.addLineToPoint(CGPointMake(0, 7))
            break
            
        case .Top, .TopRight, .TopLeft:
            trianglePath.moveToPoint(CGPointMake(0, 0))
            trianglePath.addLineToPoint(CGPointMake(12, 0))
            trianglePath.addLineToPoint(CGPointMake(6, 7))
            trianglePath.addLineToPoint(CGPointMake(0, 0))
            break
        }
        
        trianglePath.closePath()
        
        let triangleShapeLayer = CAShapeLayer()
        triangleShapeLayer.bounds = trianglePath.bounds
        triangleShapeLayer.path = trianglePath.CGPath
        triangleShapeLayer.fillColor = self.backgroundColor!.CGColor
        
        return triangleShapeLayer
    }
    
    
    private func displayInView(superview:UIView) {
        
        superview.addSubview(self)
        
        self.layoutMargins = UIEdgeInsetsMake(8, 13, 8, 13)
        self.layer.cornerRadius = 4
        
        switch self.direction {
        case .Left:
            self.layer.anchorPoint = CGPointMake(1, 0.5)
            break
        case .Right:
            self.layer.anchorPoint = CGPointMake(0, 0.5)
            break
        case .Bottom:
            self.layer.anchorPoint = CGPointMake(0.5, 0)
            break
        case .Top:
            self.layer.anchorPoint = CGPointMake(0.5, 1)
            break
        case .TopLeft:
            self.layer.anchorPoint = CGPointMake(0, 1)
            break
        case .TopRight:
            self.layer.anchorPoint = CGPointMake(1, 1)
            break
        case .BottomLeft:
            self.layer.anchorPoint = CGPointMake(0, 0)
            break
        case .BottomRight:
            self.layer.anchorPoint = CGPointMake(1, 0)
            break
        }
        
        triangleShapeLayer?.removeFromSuperlayer()
        
        triangleShapeLayer = createTriangleShapeLayer()
        self.layer.addSublayer(triangleShapeLayer)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(contentView)
        
        let constraintsAttrs = [
            NSLayoutAttribute.Top:NSLayoutAttribute.TopMargin,
            NSLayoutAttribute.Right:NSLayoutAttribute.RightMargin,
            NSLayoutAttribute.Bottom:NSLayoutAttribute.BottomMargin,
            NSLayoutAttribute.Left:NSLayoutAttribute.LeftMargin
        ]
        
        for (fromAttr, toAttr) in constraintsAttrs {
            self.addConstraint(NSLayoutConstraint(item: contentView, attribute: fromAttr, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute: toAttr, multiplier: 1, constant: 0))
        }
        
        let triangleSpacing : CGFloat = self.direction == .Bottom || self.direction == .BottomRight || self.direction == .BottomLeft || self.direction == .Top || self.direction == .TopLeft || self.direction == .TopRight ? (triangleShapeLayer.bounds.height/2 + 5)  : (triangleShapeLayer.bounds.width/2 + 5)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        switch self.direction {
            
        case .Bottom, .BottomLeft, .BottomRight:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: superview, attribute: .Bottom, multiplier: 1, constant:  triangleSpacing - (self.bounds.height / 2) ))
            break
            
        case .Top, .TopRight, .TopLeft:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: superview, attribute: .Top, multiplier: 1, constant:  (triangleSpacing - (self.bounds.height / 2)) * -1))
            break
            
        case .Left, .Right:
            superview.addConstraint(NSLayoutConstraint(item: superview, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant:  0))
            break
        }
        
        switch self.direction {
        case .Left:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: superview, attribute: .Left, multiplier: 1, constant: (triangleSpacing - (self.bounds.width / 2)) * -1))
            break
        case .BottomRight, .TopRight:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant:  ((self.bounds.width / 2)) * -1))
            break
        case .BottomLeft, .TopLeft:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant:  ((self.bounds.width / 2))))
            break
        case .Right:
            superview.addConstraint(NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: superview, attribute: .Right, multiplier: 1, constant:  triangleSpacing - (self.bounds.width / 2) ))
            break
        case .Top, .Bottom:
            self.superview?.addConstraint(NSLayoutConstraint(item: superview, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant:  0))
            break
        }
        
        if (animationEnable) {
            
            self.layer.transform = CATransform3DMakeScale(0, 0, 1)
            
            UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .AllowUserInteraction, animations: {
                
                self.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
                }, completion: { (finished) in
                    self.isVisible = finished
            })
            
        } else {
            isVisible = true
        }
    }
    
    func dismiss(remove remove:Bool) {
        if (animationEnable) {
            self.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
            UIView.animateWithDuration(0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.5, options: .AllowUserInteraction, animations: {
                
                self.layer.transform = CATransform3DMakeScale(0, 0, 1)
                
                }, completion: { (finished) in
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if (remove) { self.removeFromSuperview() }
                    })
                    self.isVisible = !finished
                    
            })
            
            
        } else {
            if (remove) { self.removeFromSuperview() }
            isVisible = false
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let triangleBounds = triangleShapeLayer.bounds
        
        switch self.direction {
        case .Left:
            triangleShapeLayer.anchorPoint = CGPointMake(0, 0.5)
            triangleShapeLayer.position = CGPointMake(self.bounds.width, self.bounds.height/2)
            break
        case .Right:
            triangleShapeLayer.anchorPoint = CGPointMake(1, 0.5)
            triangleShapeLayer.position = CGPointMake(0, self.bounds.height/2)
            break
        case .Bottom:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 1)
            triangleShapeLayer.position = CGPointMake(self.bounds.width/2, 0)
            break
        case .Top:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 0)
            triangleShapeLayer.position = CGPointMake(self.bounds.width/2, self.bounds.height)
            break
        case .TopLeft:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 0)
            triangleShapeLayer.position = CGPointMake(ZGTooltipView.triangleMargin, self.bounds.height)
            break
        case .TopRight:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 0)
            triangleShapeLayer.position = CGPointMake(self.bounds.width - ZGTooltipView.triangleMargin, self.bounds.height)
            break
        case .BottomLeft:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 1)
            triangleShapeLayer.position = CGPointMake(ZGTooltipView.triangleMargin, 0)
            break
        case .BottomRight:
            triangleShapeLayer.anchorPoint = CGPointMake(0.5, 1)
            triangleShapeLayer.position = CGPointMake(self.bounds.width - ZGTooltipView.triangleMargin, 0)
            
            break
        }
        
        triangleShapeLayer.bounds = triangleBounds
    }
    
}
