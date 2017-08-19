//
//  FabButtonsView.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/16/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import Foundation
import UIKit

class FabButtonView: UIView {
    
    weak var delegate: ViewControllerDelegate?
    
    public var options = [String]()
    
    var isMenuOpen = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupViews()
        
    }
    
    let parentContainer: UIView = {
        let pc = UIView()
        return pc
    }()
    
    let subContainer: UIView = {
        let sc = UIView()
        return sc
    }()
    
    let fabListContainer: UIView = {
        let pc = UIView()
        return pc
    }()
    
    let buttonContainer: UIView = {
        let bc = UIView()
        return bc
    }()
    
    func closePalette() {
        delegate?.closePalette()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func toggleFabList() {

    }
    
    func setupFloaty() {
        Floaty.global.button.addItem(icon: UIImage(named: "freeze")!)
        Floaty.global.button.addItem(icon: UIImage(named: "flash")!)
        Floaty.global.button.addItem(icon: UIImage(named: "hue")!)
        Floaty.global.button.addItem(icon: UIImage(named: "color_blind")!)
        Floaty.global.show()
    }
    
    
    func setupViews() {
        
//        setupFloaty()

        buttonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.toggleFabList)))
        
        subContainer.addSubview(buttonContainer)
        
        subContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: buttonContainer)
        subContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: buttonContainer)
        
        parentContainer.addSubview(subContainer)
        parentContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: subContainer)
        parentContainer.addConstraintsWithFormat(format: "H:|[v0]|", views: subContainer)
        
        addSubview(parentContainer)
        addConstraintsWithFormat(format: "V:|[v0]|", views: parentContainer)
        addConstraintsWithFormat(format: "H:|[v0]|", views: parentContainer)

    }
}
