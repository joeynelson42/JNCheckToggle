//
//  ViewController.swift
//  spinningCheckmark
//
//  Created by Joey Nelson on 7/1/16.
//  Copyright © 2016 Joey Nelson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JNCheckToggleDelegate {
    
    let mainView = View()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = mainView
        mainView.check.delegate = self
    }
    
    func checkStateChanged(state: CheckToggleState) {
        print("hey! \(state)")
    }
}

