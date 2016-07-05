//
//  View.swift
//  spinningCheckmark
//
//  Created by Joey Nelson on 7/1/16.
//  Copyright © 2016 Joey Nelson. All rights reserved.
//

import UIKit

class View: UIView {
    
    // MARK: Properties
    let check = JNCheckToggle()
    let checkDark = JNCheckToggle()
    let checkLarge = JNCheckToggle()
    
    // MARK: Inits
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    override func updateConstraints() {
        super.updateConstraints()
        configureSubviews()
        applyConstraints()
    }
    
    func configureSubviews(){
        self.backgroundColor = UIColor.whiteColor()
        
        check.setUntoggledColor(.whiteColor())
        check.setToggledColor(.purpleColor())
        check.style = .light
        
        checkDark.setUntoggledColor(.whiteColor())
        checkDark.setToggledColor(.cyanColor())
        checkDark.style = .dark
        
        checkLarge.setUntoggledColor(.whiteColor())
        checkLarge.setToggledColor(.greenColor())
        checkLarge.style = .light
        checkLarge.diameter = 100
        
        addSubview(check)
        addSubview(checkDark)
        addSubview(checkLarge)
    }
    
    func applyConstraints() {
        
        check.translatesAutoresizingMaskIntoConstraints = false
        checkDark.translatesAutoresizingMaskIntoConstraints = false
        checkLarge.translatesAutoresizingMaskIntoConstraints = false
        
        let checkCX = NSLayoutConstraint(item: check,
                                         attribute: .CenterX,
                                         relatedBy: .Equal,
                                         toItem: self,
                                         attribute: .CenterX,
                                         multiplier: 1.0,
                                         constant: 0)
        
        let checkTT = NSLayoutConstraint(item: check,
                                         attribute: .Top,
                                         relatedBy: .Equal,
                                         toItem: self,
                                         attribute: .Top,
                                         multiplier: 1.0,
                                         constant: 50)
        
        let checkW = NSLayoutConstraint(item: check,
                                        attribute: .Width,
                                        relatedBy: .Equal,
                                        toItem: nil,
                                        attribute: .NotAnAttribute,
                                        multiplier: 1.0,
                                        constant: 50)
        
        let checkH = NSLayoutConstraint(item: check,
                                        attribute: .Height,
                                        relatedBy: .Equal,
                                        toItem: nil,
                                        attribute: .NotAnAttribute,
                                        multiplier: 1.0,
                                        constant: 50)
        
        let checkDarkCX = NSLayoutConstraint(item: checkDark,
                                         attribute: .CenterX,
                                         relatedBy: .Equal,
                                         toItem: self,
                                         attribute: .CenterX,
                                         multiplier: 1.0,
                                         constant: 0)
        
        let checkDarkTB = NSLayoutConstraint(item: checkDark,
                                         attribute: .Top,
                                         relatedBy: .Equal,
                                         toItem: check,
                                         attribute: .Bottom,
                                         multiplier: 1.0,
                                         constant: 50)
        
        let checkDarkW = NSLayoutConstraint(item: checkDark,
                                        attribute: .Width,
                                        relatedBy: .Equal,
                                        toItem: nil,
                                        attribute: .NotAnAttribute,
                                        multiplier: 1.0,
                                        constant: 50)
        
        let checkDarkH = NSLayoutConstraint(item: checkDark,
                                        attribute: .Height,
                                        relatedBy: .Equal,
                                        toItem: nil,
                                        attribute: .NotAnAttribute,
                                        multiplier: 1.0,
                                        constant: 50)
        
        let checkLargeCX = NSLayoutConstraint(item: checkLarge,
                                             attribute: .CenterX,
                                             relatedBy: .Equal,
                                             toItem: self,
                                             attribute: .CenterX,
                                             multiplier: 1.0,
                                             constant: 0)
        
        let checkLargeTB = NSLayoutConstraint(item: checkLarge,
                                             attribute: .Top,
                                             relatedBy: .Equal,
                                             toItem: checkDark,
                                             attribute: .Bottom,
                                             multiplier: 1.0,
                                             constant: 50)
        
        let checkLargeW = NSLayoutConstraint(item: checkLarge,
                                            attribute: .Width,
                                            relatedBy: .Equal,
                                            toItem: nil,
                                            attribute: .NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        
        let checkLargeH = NSLayoutConstraint(item: checkLarge,
                                            attribute: .Height,
                                            relatedBy: .Equal,
                                            toItem: nil,
                                            attribute: .NotAnAttribute,
                                            multiplier: 1.0,
                                            constant: 100)
        
        checkCX.active = true
        checkTT.active = true
        checkW.active = true
        checkH.active = true
        
        checkDarkCX.active = true
        checkDarkTB.active = true
        checkDarkW.active = true
        checkDarkH.active = true
        
        checkLargeCX.active = true
        checkLargeTB.active = true
        checkLargeW.active = true
        checkLargeH.active = true
    }
    
    
}