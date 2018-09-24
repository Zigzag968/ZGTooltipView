//
//  ZGTooltipView.swift
//  ZGTooltipView
//
//  Created by Alexandre Guibert on 22/05/2016.
//  Copyright © 2016 Zigzag. All rights reserved.
//

import UIKit

private var tooltipViewKey: UInt8 = 0

extension UIView {
    public weak var tooltipView: ZGTooltipView? {
        get {
            return objc_getAssociatedObject(self, &tooltipViewKey) as? ZGTooltipView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tooltipViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

open class ZGTooltipView: UIView {
    static let triangleMargin: CGFloat = 10

    open override var backgroundColor: UIColor? {
        didSet {
            triangleShapeLayer?.fillColor = backgroundColor?.cgColor
        }
    }

    open override var frame: CGRect {
        didSet {
            // print(self)
        }
    }

    fileprivate weak var originView: UIView?

    fileprivate var isVisible = false

    fileprivate var contentView: UIView
    fileprivate var direction: Direction
    fileprivate var triangleShapeLayer: CAShapeLayer!
    fileprivate var removeOnDismiss: Bool
    fileprivate var dismissTimer: Timer?

    var hostingView: UIView! { return UIApplication.shared.keyWindow! }
    lazy var tooltipTapGesture = UITapGestureRecognizer(target: self, action: #selector(ZGTooltipView.tapGestureHandler))

    @objc public enum Direction: Int {
        case left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight
    }

    /**
     Create a tooltip associated to a view

     - Parameter direction: Direction of the tooltip
     - Parameter text: Text to display in the tooltip
     - Parameter originView: View which will be attached to the tooltip. It will be use to positionate the tooltip.
     - Parameter removeOnDismiss: Boolean indicating whether the tooltip should be remove from the view hierarchy on dismiss.
     */
    public convenience init(direction: Direction, text: String, originView: UIView, removeOnDismiss: Bool = true) {
        self.init(direction: direction, customView: ZGTooltipView.createLabel(text: text), originView: originView, removeOnDismiss: removeOnDismiss)
    }

    /**
     Create a tooltip associated to a view

     - Parameter direction: Direction of the tooltip
     - Parameter customView: View that will be added inside the tooltip
     - Parameter originView: View which will be attached to the tooltip. It will be use to positionate the tooltip.
     - Parameter removeOnDismiss: Boolean indicating whether the tooltip should be remove from the view hierarchy on dismiss.
     */
    public required init(direction: Direction, customView: UIView, originView: UIView, removeOnDismiss: Bool = true) {
        self.originView = originView
        self.direction = direction
        contentView = customView
        self.removeOnDismiss = removeOnDismiss

        super.init(frame: CGRect.zero)

        tooltipView = self

        originView.addGestureRecognizer(tooltipTapGesture)
        tooltipTapGesture.delegate = self
        setup()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tapGestureHandler() {
        !isVisible ? displayTooltip() : dismiss(remove: removeOnDismiss, completion: nil)
    }

    fileprivate func setup() {
        if #available(iOS 11.0, *) {
            self.insetsLayoutMarginsFromSafeArea = false
        }

        backgroundColor = UIColor(white: 0, alpha: 0.8)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentView)

        for (fromAttr, toAttr) in [
            NSLayoutAttribute.top: NSLayoutAttribute.topMargin,
            NSLayoutAttribute.right: NSLayoutAttribute.rightMargin,
            NSLayoutAttribute.bottom: NSLayoutAttribute.bottomMargin,
            NSLayoutAttribute.left: NSLayoutAttribute.leftMargin,
        ] {
            addConstraint(NSLayoutConstraint(item: contentView, attribute: fromAttr, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: toAttr, multiplier: 1, constant: 0))
        }
    }

    fileprivate static func createLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.white
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width * 0.7))

        return label
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

    /**
     Display the tooltip according to the provided origin

     - Parameter originView: UIView to use to positionnate the tooltip
     */
    public func displayTooltip(completion: (() -> Void)? = nil) {
        dismissTimer?.invalidate()

        self.isHidden = false
        guard !isVisible else { return }

        hostingView.addSubview(self)

        self.layoutMargins = UIEdgeInsetsMake(8, 13, 8, 13)
        self.layer.cornerRadius = 4

        triangleShapeLayer?.removeFromSuperlayer()
        triangleShapeLayer = createTriangleShapeLayer()
        self.layer.addSublayer(triangleShapeLayer)

        updatePosition()

        self.isVisible = true

        completion?()

        self.setNeedsLayout()
    }

    public func dismiss(remove: Bool, completion: (() -> Void)? = nil) {
        guard isVisible else { completion?(); return }

        isVisible = false
        self.isHidden = true

        if remove { self.removeFromSuperview() }

        DispatchQueue.main.async(execute: {
            completion?()
        })
    }

    public func updatePosition() {
        guard let originView = self.originView, superview != nil else { return }

        let triangleYSpacing: CGFloat = triangleShapeLayer.bounds.height / 2 + 5
        let triangleXSpacing: CGFloat = ZGTooltipView.triangleMargin

        let size = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)

        var computedOrigin = CGPoint.zero
        let convertedOrigin = hostingView.convert(computedOrigin, from: originView)

        switch self.direction {
        case .bottom, .bottomLeft, .bottomRight:
            computedOrigin.y = convertedOrigin.y + originView.frame.height + triangleYSpacing
            break

        case .top, .topRight, .topLeft:
            computedOrigin.y = convertedOrigin.y - size.height - triangleYSpacing
            break

        case .left, .right:
            computedOrigin.y = convertedOrigin.y - (size.height / 2) + (originView.frame.height / 2)
            break
        }

        switch self.direction {
        case .left:
            computedOrigin.x = convertedOrigin.x - size.width - triangleXSpacing
            break

        case .bottomRight, .topRight:
            computedOrigin.x = convertedOrigin.x - size.width + (originView.frame.width / 2) + triangleXSpacing
            break

        case .bottomLeft, .topLeft:
            computedOrigin.x = convertedOrigin.x + (originView.frame.width / 2) - triangleXSpacing
            break

        case .right:
            computedOrigin.x = convertedOrigin.x + originView.frame.width + triangleXSpacing
            break

        case .top, .bottom:
            computedOrigin.x = convertedOrigin.x - (size.width / 2) + (originView.frame.width / 2)
            break
        }

        self.frame = CGRect(origin: computedOrigin, size: size)

        // self.layoutIfNeeded()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        updatePosition()

        let triangleBounds = triangleShapeLayer.bounds

        switch self.direction {
        case .left:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width, y: self.bounds.height / 2)
            break
        case .right:
            triangleShapeLayer.anchorPoint = CGPoint(x: 1, y: 0.5)
            triangleShapeLayer.position = CGPoint(x: 0, y: self.bounds.height / 2)
            break
        case .bottom:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width / 2, y: 0.25)
            break
        case .top:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width / 2, y: self.bounds.height - 0.25)
            break
        case .topLeft:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: ZGTooltipView.triangleMargin, y: self.bounds.height - 0.25)
            break
        case .topRight:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width - ZGTooltipView.triangleMargin, y: self.bounds.height - 0.25)
            break
        case .bottomLeft:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: ZGTooltipView.triangleMargin, y: 0.25)
            break
        case .bottomRight:
            triangleShapeLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
            triangleShapeLayer.position = CGPoint(x: self.bounds.width - ZGTooltipView.triangleMargin, y: 0.25)

            break
        }

        triangleShapeLayer.bounds = triangleBounds
    }

    @objc func timerDidFire() {
        dismiss(remove: removeOnDismiss)
    }

    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        dismissTimer?.invalidate()
        dismissTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ZGTooltipView.timerDidFire), userInfo: nil, repeats: false)

        return super.hitTest(point, with: event)
    }
}

extension ZGTooltipView: UIGestureRecognizerDelegate {
    open override func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        return !isVisible
    }
}
