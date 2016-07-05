//
//  JNCheckToggle.swift
//  spinningCheckmark
//
//  Created by Joey Nelson on 7/1/16.
//  Copyright © 2016 Joey Nelson. All rights reserved.
//

protocol JNCheckToggleDelegate {
    
    /**
     Called when the state of the checkToggle changes.
     
     :param: state The new state of the checkToggle.
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

enum CheckToggleStyle {
    case none
    case light
    case dark
}

struct AnimationValues {
    var cornerRadius: CGFloat!
    var color: UIColor!
    var rotation: Float!
    var borderWidth: CGFloat!
}

import UIKit

@IBDesignable class JNCheckToggle: UIView {
    
    // MARK: Properties
    private let containerView = UIButton()
    private let checkmark = UIImageView()
    
    /// Alerted on state change
    internal var delegate: JNCheckToggleDelegate?
    
    /// The state of the checkToggle
    internal var state = CheckToggleState.untoggled
    
    /// The color of the checkmark
    internal var style = CheckToggleStyle.light {
        didSet {
            configureStyle()
        }
    }
    
    /// The duration of the toggle animation
    internal var duration = 0.4
    
    /// The untoggled cornerRadius
    internal var initialCornerRadius: CGFloat = 2.0
    
    /// The diameter of the checkToggle
    internal var diameter:CGFloat = 40
    
    ///Contains the values for the untoggled checkmark, configure with ::configureToggledValues
    private var fromValues = AnimationValues(cornerRadius: 0, color: UIColor.whiteColor(), rotation: 0, borderWidth: 1.0)
    
    ///Contains the values for the toggled checkmark, configure with ::configureUntoggledValues
    private var toValues = AnimationValues(cornerRadius: 0, color: UIColor.whiteColor(), rotation: 0, borderWidth: 0.0)
    
    // MARK: Inits
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    convenience init(initialState: CheckToggleState, style: CheckToggleStyle = CheckToggleStyle.light) {
        self.init(frame: CGRectZero)
        self.state = initialState
        self.style = style
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
     Set the color of the untoggled checkToggle
     
     :param: color The untoggled color.

     */
    func setUntoggledColor(color: UIColor = UIColor.whiteColor()) {
        fromValues = AnimationValues(cornerRadius: initialCornerRadius, color: color, rotation: Float(M_PI), borderWidth: 0.5)
        if state == .untoggled {
            configureWithAnimationValues(fromValues)
        }
    }
    
    /**
     Set the color of the toggled checkToggle
     
     :param: color The toggled color.
     
     */
    func setToggledColor(color: UIColor = UIColor.whiteColor()) {
        toValues = AnimationValues(cornerRadius: diameter/2, color: color, rotation: 0, borderWidth: 0.0)
        if state == .toggled {
            configureWithAnimationValues(toValues)
        }
    }
    
    // MARK: Private Methods
    // MARK: Animations
    
    ///Toggles the checkmark
    private func toggleOn() {
        
        let containerAnimations = createContainerAnimation(fromValues, endValues: toValues)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            guard let _ = self.delegate else { return }
            self.delegate!.checkStateChanged(self.state)
        }
        containerView.layer.addAnimation(containerAnimations, forKey: "startContainerAnimations")
        containerView.layer.cornerRadius = self.toValues.cornerRadius
        containerView.backgroundColor = self.toValues.color
        containerView.layer.borderWidth = toValues.borderWidth
        CATransaction.commit()
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
            self.checkmark.alpha = 1.0
            self.checkmark.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
    }
    
    ///Untoggles the checkmark
    private func toggleOff() {
        
        let containerAnimations = createContainerAnimation(toValues, endValues: fromValues)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            guard let _ = self.delegate else { return }
            self.delegate!.checkStateChanged(self.state)
        }
        containerView.layer.addAnimation(containerAnimations, forKey: "startContainerAnimations")
        containerView.layer.cornerRadius = self.fromValues.cornerRadius
        containerView.backgroundColor = self.fromValues.color
        containerView.layer.borderWidth = fromValues.borderWidth

        CATransaction.commit()
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
            self.checkmark.alpha = 0.0
            self.checkmark.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
            }, completion: nil)
    }
    
    private func createContainerAnimation(startValues: AnimationValues, endValues: AnimationValues) -> CAAnimationGroup {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = startValues.rotation
        rotationAnimation.toValue = endValues.rotation
        
        let cornerRadiusAnimation = CABasicAnimation(keyPath:"cornerRadius")
        cornerRadiusAnimation.fromValue = startValues.cornerRadius
        cornerRadiusAnimation.toValue = endValues.cornerRadius
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = startValues.color
        colorAnimation.toValue = endValues.color
        
        let borderWidth = CABasicAnimation(keyPath: "borderWidth")
        borderWidth.fromValue = startValues.borderWidth
        borderWidth.toValue = endValues.borderWidth
        
        let animations:CAAnimationGroup = CAAnimationGroup()
        animations.animations = [rotationAnimation, cornerRadiusAnimation, colorAnimation, borderWidth]
        animations.duration = duration
        animations.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return animations
    }
    
    // MARK: View Configuration
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    private func configureSubviews() {
        backgroundColor = .clearColor()
        clipsToBounds = false
        
        containerView.layer.borderColor = UIColor.darkGrayColor().CGColor
        containerView.layer.borderWidth = 0.5
        containerView.addTarget(self, action: #selector(JNCheckToggle.animateToggle), forControlEvents: .TouchUpInside)

        checkmark.transform = CGAffineTransformMakeScale(0.0001, 0.0001)
        configureStyle()
        
        checkmark.contentMode = .ScaleAspectFit
        
        addSubview(containerView)
        addSubview(checkmark)
    }
    
    private func applyConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        
        let containerCenterX = NSLayoutConstraint(item: containerView,
                                                  attribute: .CenterX,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterX,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let containerCenterY = NSLayoutConstraint(item: containerView,
                                                  attribute: .CenterY,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterY,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let containerCenterWidth = NSLayoutConstraint(item: containerView,
                                                  attribute: .Width,
                                                  relatedBy: .Equal,
                                                  toItem: nil,
                                                  attribute: .NotAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: diameter)
        
        let containerCenterHeight = NSLayoutConstraint(item: containerView,
                                                  attribute: .Height,
                                                  relatedBy: .Equal,
                                                  toItem: nil,
                                                  attribute: .NotAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: diameter)
        
        
        let checkmarkCenterX = NSLayoutConstraint(item: checkmark,
                                                  attribute: .CenterX,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterX,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let checkmarkCenterY = NSLayoutConstraint(item: checkmark,
                                                  attribute: .CenterY,
                                                  relatedBy: .Equal,
                                                  toItem: self,
                                                  attribute: .CenterY,
                                                  multiplier: 1.0,
                                                  constant: 0)
        
        let checkmarkCenterWidth = NSLayoutConstraint(item: checkmark,
                                                      attribute: .Width,
                                                      relatedBy: .Equal,
                                                      toItem: nil,
                                                      attribute: .NotAnAttribute,
                                                      multiplier: 1.0,
                                                      constant: diameter * 0.7)
        
        let checkmarkCenterHeight = NSLayoutConstraint(item: checkmark,
                                                       attribute: .Height,
                                                       relatedBy: .Equal,
                                                       toItem: nil,
                                                       attribute: .NotAnAttribute,
                                                       multiplier: 1.0,
                                                       constant: diameter * 0.7)
        
        containerCenterX.active = true
        containerCenterY.active = true
        containerCenterWidth.active = true
        containerCenterHeight.active = true
        
        checkmarkCenterX.active = true
        checkmarkCenterY.active = true
        checkmarkCenterWidth.active = true
        checkmarkCenterHeight.active = true
    }
    
    private func configureWithAnimationValues(values: AnimationValues) {
        containerView.backgroundColor = values.color
        containerView.layer.cornerRadius = values.cornerRadius
    }
    
    private func configureStyle() {
        switch style {
        case .none:
            checkmark.hidden = true
        case .light:
            checkmark.image = UIImage(named: "lightCheckmark")
        case .dark:
            checkmark.image = UIImage(named: "darkCheckmark")
        }
    }
}