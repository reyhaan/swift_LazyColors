//
//  PreviewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

protocol PreviewControllerDelegate: class {
    func goBackToCamera()
}

class PreviewController: UIViewController, UINavigationControllerDelegate, PreviewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setupViews()
        
        colorsList.delegate = self
        
    }
    
    let colorsList = ColorCollectionView()
    
    func goBackToCamera() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
    
    func setupViews() {
        
        view.addSubview(colorsList)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: colorsList)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: colorsList)
        
    }

}
