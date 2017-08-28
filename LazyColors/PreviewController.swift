//
//  PreviewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import MessageUI

protocol PreviewControllerDelegate: class {
    func goBackToCamera()
    func reloadData()
}

class PreviewController: UIViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, PreviewControllerDelegate {
    
    weak var delegate: ViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        setupViews()
        
        colorPortal.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorPortal.pageView.reloadData()
    }
    
    let cd = ColorDetails()
    
    let colorPortal = ColorPortalView() // ColorCollectionView()
    
    func goBackToCamera() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
    
    func reloadData() {
        colorPortal.pageView.reloadData()
    }
    
    func setupViews() {
        
        view.addSubview(colorPortal)

        view.addConstraintsWithFormat(format: "H:|[v0]|", views: colorPortal)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: colorPortal)
        
    }

}
