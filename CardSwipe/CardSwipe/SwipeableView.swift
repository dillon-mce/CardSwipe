//
//  SwipeableView.swift
//  CardSwipe
//
//  Created by Dillon McElhinney on 7/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

open class SwipeableView: UIView, UIGestureRecognizerDelegate {
    
    var delegate: SwipeableViewDelegate?
    
    // MARK: Gesture Recognizer
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var panGestureTranslation: CGPoint = .zero
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    // MARK: Drag Animation Settings
    
    static var maximumRotation: CGFloat = 1.0
    
    static var rotationAngle: CGFloat = CGFloat(Double.pi) / 10.0
    
    static var animationDirectionY: CGFloat = 1.0
    
    static var swipePercentageMargin: CGFloat = 0.7
    
    // MARK: Card Finalize Swipe Animation
    
    static var finalizeSwipeActionAnimationDuration: TimeInterval = 0.2
    
    // MARK: Card Reset Animation
    
    static var cardViewResetAnimationDamping: CGFloat = 18.0
    
    static var cardViewResetAnimationInitialVelocity: CGFloat = 10.0
    
    static var cardViewResetAnimationStiffness: CGFloat = 160
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGestureRecognizers()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizers()
    }
    
    deinit {
        if let panGestureRecognizer = panGestureRecognizer {
            removeGestureRecognizer(panGestureRecognizer)
        }
        if let tapGestureRecognizer = tapGestureRecognizer {
            removeGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private func setupGestureRecognizers() {
        // Pan Gesture Recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeableView.panGestureRecognized(_:)))
        self.panGestureRecognizer = panGestureRecognizer
        addGestureRecognizer(panGestureRecognizer)
        
        // Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized(_:)))
        tapGestureRecognizer.delegate = self
        self.tapGestureRecognizer = tapGestureRecognizer
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Pan Gesture Recognizer
    
    @objc private func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
        panGestureTranslation = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        case .began:
            let initialTouchPoint = gestureRecognizer.location(in: self)
            let newAnchorPoint = CGPoint(x: initialTouchPoint.x / bounds.width, y: initialTouchPoint.y / bounds.height)
            let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
            let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
            layer.anchorPoint = newAnchorPoint
            layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
            
            removeAnimations()
            layer.rasterizationScale = UIScreen.main.scale
            layer.shouldRasterize = true
            delegate?.didBeginSwipe(onView: self)
        case .changed:
            let rotationStrength = min(panGestureTranslation.x / frame.width, SwipeableView.maximumRotation)
            let rotationAngle = SwipeableView.animationDirectionY * SwipeableView.rotationAngle * rotationStrength
            
            var transform = CATransform3DIdentity
            transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
            transform = CATransform3DTranslate(transform, panGestureTranslation.x, panGestureTranslation.y, 0)
            layer.transform = transform
        case .ended:
            endedPanAnimation()
            layer.shouldRasterize = false
        default:
            resetCardViewPosition()
            layer.shouldRasterize = false
        }
    }
    
    private var dragDirection: SwipeDirection? {
        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(bounds.size)
        return SwipeDirection.allDirections.reduce((distance: CGFloat.infinity, direction: nil), { closest, direction -> (CGFloat, SwipeDirection?) in
            let distance = direction.point.distanceTo(normalizedDragPoint)
            if distance < closest.distance {
                return (distance, direction)
            }
            return closest
        }).direction
    }
    
    private var dragPercentage: CGFloat {
        guard let dragDirection = dragDirection else { return 0.0 }
        
        let normalizedDragPoint = panGestureTranslation.normalizedDistanceForSize(frame.size)
        let swipePoint = normalizedDragPoint.scalarProjectionPointWith(dragDirection.point)
        
        let rect = SwipeDirection.boundsRect
        
        if !rect.contains(swipePoint) {
            return 1.0
        } else {
            let centerDistance = swipePoint.distanceTo(.zero)
            let targetLine = (swipePoint, CGPoint.zero)
            
            return rect.perimeterLines
                .compactMap { CGPoint.intersectionBetweenLines(targetLine, line2: $0) }
                .map { centerDistance / $0.distanceTo(.zero) }
                .min() ?? 0.0
        }
    }
    
    private func endedPanAnimation() {
        if let dragDirection = dragDirection, dragPercentage >= SwipeableView.swipePercentageMargin, dragDirection != .up, dragDirection != .down {
            CATransaction.begin()
            let translationAnimation = CABasicAnimation(keyPath: "transform")
            translationAnimation.duration = SwipeableView.finalizeSwipeActionAnimationDuration
            translationAnimation.fromValue = layer.transform
            let endPoint = animationPointForDirection(dragDirection)
            let endTransform = CATransform3DTranslate(layer.transform, endPoint.x, endPoint.y, 0)
            translationAnimation.toValue = endTransform
            layer.transform = endTransform
            
            CATransaction.setCompletionBlock {
                self.delegate?.didEndSwipe(onView: self, in: dragDirection)
            }
            layer.add(translationAnimation, forKey: "transform")
            CATransaction.commit()
        } else {
            resetCardViewPosition()
        }
    }
    
    private func animationPointForDirection(_ direction: SwipeDirection) -> CGPoint {
        let point = direction.point
        let animatePoint = CGPoint(x: point.x * 400, y: point.y * 400)
//        let retPoint = animatePoint.screenPointForSize(UIScreen.main.bounds.size)
        return animatePoint
    }
    
    private func resetCardViewPosition() {
        removeAnimations()
        
        // Reset Translation
        let resetPositionAnimation = CASpringAnimation(keyPath: "transform")
        resetPositionAnimation.fromValue = layer.transform
        resetPositionAnimation.toValue = CATransform3DIdentity
        resetPositionAnimation.initialVelocity = SwipeableView.cardViewResetAnimationInitialVelocity
        resetPositionAnimation.damping = SwipeableView.cardViewResetAnimationDamping
        resetPositionAnimation.stiffness = SwipeableView.cardViewResetAnimationStiffness
        resetPositionAnimation.duration = resetPositionAnimation.settlingDuration
        layer.transform = CATransform3DIdentity
        layer.add(resetPositionAnimation, forKey: "transform")
    }
    
    private func removeAnimations() {
        layer.removeAllAnimations()
    }
    
    // MARK: - Tap Gesture Recognizer

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func tapRecognized(_ recognizer: UITapGestureRecognizer) {
        delegate?.didTap(view: self)
    }
    
}
