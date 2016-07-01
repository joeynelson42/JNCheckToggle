//
//  JNCheckToggle.swift
//  spinningCheckmark
//
//  Created by Joey Nelson on 7/1/16.
//  Copyright © 2016 Joey Nelson. All rights reserved.
//

protocol JNCheckToggleDelegate {
    
    /**
     Called when the state of the checkToggle changes
     
     :param: state The new state of the checkToggle
     */
    func checkStateChanged(state: CheckToggleState)
}

extension JNCheckToggleDelegate {
    func checkStateChanged(state: CheckToggleState) {
        print("hey! the checkToggle is now \(state)")
    }
}

enum CheckToggleState {
    case toggled
    case untoggled
}

struct AnimationValues {
    var cornerRadius: CGFloat!
    var color: UIColor!
    var rotation: Float!
}

import UIKit

class JNCheckToggle: UIView {
    
    // MARK: Properties
    private let containerView = UIButton()
    private let checkmark = UIImageView()
    
    /// The state of the checkToggle
    internal var state = CheckToggleState.untoggled
    
    internal var delegate: JNCheckToggleDelegate?
    
    /// The duration of the toggle animation
    internal var duration = 0.4
    
    ///Contains the values for the untoggled checkmark, configure with ::configureToggledValues
    private var fromValues = AnimationValues(cornerRadius: 0, color: UIColor.whiteColor(), rotation: 0)
    
    ///Contains the values for the toggled checkmark, configure with ::configureUntoggledValues
    private var toValues = AnimationValues(cornerRadius: 0, color: UIColor.whiteColor(), rotation: 0)
    
    // MARK: Inits
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    convenience init(initialState: CheckToggleState) {
        self.init(frame: CGRectZero)
        self.state = initialState
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    func animateToggle() {
        switch state {
        case .untoggled:
            toggleOn()
            state = .toggled
        case .toggled:
            toggleOff()
            state = .untoggled
        }
    }
    
    /**
     Set the values of the untoggled checkToggle
     
     :param: cornerRadius The untoggled corner radius.
     :param: color The untoggled color.
     :param: rotation The rotation distance on toggle (Clockwise)

     */
    func setUntoggledValues(cornerRadius cornerRadius: CGFloat = 0, color: UIColor = UIColor.whiteColor(), rotation: Float = Float(M_PI)) {
        fromValues = AnimationValues(cornerRadius: cornerRadius, color: color, rotation: rotation)
        if state == .untoggled {
            configureWithAnimationValues(fromValues)
        }
    }
    
    /**
     Set the values of the toggled checkToggle
     
     :param: cornerRadius The toggled corner radius.
     :param: color The toggled color.
     :param: rotation The rotation distance on untoggle (Counter-Clockwise)
     
     */
    func setToggledValues(cornerRadius cornerRadius: CGFloat = 0, color: UIColor = UIColor.whiteColor(), rotation: Float = Float(M_PI)) {
        toValues = AnimationValues(cornerRadius: cornerRadius, color: color, rotation: rotation)
        if state == .toggled {
            configureWithAnimationValues(toValues)
        }
    }
    
    // MARK: Private Methods
    // MARK: Animations
    
    ///Toggles the checkmark using simple CAAnimations
    private func toggleOn() {
        
        let containerAnimations = createContainerAnimation(fromValues, endValues: toValues)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            guard let _ = self.delegate else { return }
            self.delegate!.checkStateChanged(self.state)
        }
        containerView.layer.addAnimation(containerAnimations, forKey: "startContainerAnimations")
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
            self.checkmark.alpha = 1.0
            self.checkmark.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        
        containerView.layer.cornerRadius = self.toValues.cornerRadius
        containerView.backgroundColor = self.toValues.color
        checkmark.alpha = 1.0
        checkmark.transform = CGAffineTransformMakeScale(1.0, 1.0)
        CATransaction.commit()
    }
    
    ///Untoggles the checkmark using simple CAAnimations
    private func toggleOff() {
        
        let containerAnimations = createContainerAnimation(toValues, endValues: fromValues)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            guard let _ = self.delegate else { return }
            self.delegate!.checkStateChanged(self.state)
        }
        containerView.layer.addAnimation(containerAnimations, forKey: "startContainerAnimations")
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { 
            self.checkmark.alpha = 0.0
            self.checkmark.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }, completion: nil)
        
        containerView.layer.cornerRadius = self.fromValues.cornerRadius
        containerView.backgroundColor = self.fromValues.color
        checkmark.alpha = 0.0
        checkmark.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
        CATransaction.commit()
    }
    
    private func createContainerAnimation(startValues: AnimationValues, endValues: AnimationValues) -> CAAnimationGroup {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        rotationAnimation.damping = 10
//        rotationAnimation.mass = 1
        rotationAnimation.fromValue = startValues.rotation
        rotationAnimation.toValue = endValues.rotation
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath:"cornerRadius")
        cornerRadiusAnimation.fromValue = startValues.cornerRadius
        cornerRadiusAnimation.toValue = endValues.cornerRadius
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = startValues.color
        colorAnimation.toValue = endValues.color
        
        let animations:CAAnimationGroup = CAAnimationGroup()
        animations.animations = [rotationAnimation, cornerRadiusAnimation, colorAnimation]
        animations.duration = duration
        animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animations
    }
    
//    private func createCheckAnimation() -> CAAnimationGroup {
//        let checkScale = CABasicAnimation(keyPath: "transform.scale")
//        let checkAlpha = CABasicAnimation(keyPath: "alpha")
//        if state == .toggled{
//            checkScale.fromValue = 1.0
//            checkScale.toValue = 0.01
//            
//            checkAlpha.fromValue = 1.0
//            checkAlpha.toValue = 0.0
//        } else {
//            checkScale.fromValue = 0.01
//            checkScale.toValue = 1.0
//            
//            checkAlpha.fromValue = 0.0
//            checkAlpha.toValue = 1.0
//        }
//
//        
//        
//        let animations = CAAnimationGroup()
//        animations.animations = [checkScale, checkAlpha]
//        animations.duration = duration
//        animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//        
//        return animations
//    }
    
    // MARK: View Configuration
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    private func configureSubviews() {
        backgroundColor = .clearColor()
        
        containerView.layer.cornerRadius = 5.0
        containerView.addTarget(self, action: #selector(JNCheckToggle.animateToggle), forControlEvents: .TouchUpInside)

        checkmark.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
        
        checkmark.image = UIImage(named: "lightCheckmark")
        checkmark.contentMode = .ScaleAspectFit
        
        addSubview(containerView)
        addSubview(checkmark)
    }
    
    private func applyConstraints() {
        containerView.fillSuperview()
        
        checkmark.addConstraints(
            Constraint.llrr.of(self, offset: 3),
            Constraint.ttbb.of(self, offset: 3)
        )
    }
    
    private func configureWithAnimationValues(values: AnimationValues) {
        containerView.backgroundColor = values.color
        containerView.layer.cornerRadius = values.cornerRadius
    }
}