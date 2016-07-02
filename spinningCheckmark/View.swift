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
        
        check.setUntoggledValues(.whiteColor(), rotation: 0)
        check.setToggledValues(.dodger(), rotation: Float(M_PI))
        check.style = CheckToggleStyle.light
        addSubview(check)
    }
    
    func applyConstraints() {
        check.addConstraints(
            Constraint.cxcx.of(self),
            Constraint.cycy.of(self),
            Constraint.wh.of(50)
        )
    }
}