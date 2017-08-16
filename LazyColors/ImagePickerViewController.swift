//
//  ImagePickerViewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/15/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit

protocol ImagePickerViewControllerDelegate: class {
    func openColorsList()
}

class ImagePickerViewController: UIViewController, UINavigationControllerDelegate, ImagePickerViewControllerDelegate {
    
    var pickedImage: UIImage?
    var scrollView: ImageScrollView?
    var imagePicker: ImagePickerControls?
    var touchX: CGFloat?
    var touchY: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        scrollView = ImageScrollView(image: pickedImage!)
        
        view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateTargetIcon)))
        
        // calculate center position for target
        touchX = (self.view.frame.width / 2)
        touchY = (self.view.frame.height / 2)
        
        setupViews()
        
        imagePicker = headerContainer
        imagePicker?.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Manage display on rotation.
        scrollView?.updateMinZoomScaleForSize(view.bounds.size)
    }
    
    let headerContainer: ImagePickerControls = {
        let hc = ImagePickerControls()
        hc.backgroundColor = UIColor.black
        return hc
    }()
    
    let targetIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "target_white")
        return img
    }()
    
    let target: UIView = {
        let tg = UIView()
        tg.backgroundColor = UIColor.clear
        tg.frame.size.height = 10
        tg.frame.size.width = 10
        return tg
    }()
    
    func updateTargetIcon(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        touchX = (location.x)
        touchY = (location.y)
        target.frame.origin.x = touchX! - 9
        target.frame.origin.y = touchY! - 9

    }
    
    let pc = PreviewController()
    
    func openColorsList() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(pc, animated: false)
    }
    
    func setupViews() {
        
        // set target icon here
        targetIcon.frame.size.height = 18
        targetIcon.frame.size.width = 18
        
        // inject target's icon to target view
        target.addSubview(targetIcon)
        
        // set target initial postion
        target.frame.origin.x = touchX! - 9
        target.frame.origin.y = touchY! - 9
        
        view.addSubview(scrollView!)
        view.addSubview(headerContainer)
        
        view.addSubview(target)
        
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(90)]-(-20)-|", views: scrollView!, headerContainer)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContainer)

//        scrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
