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
    func closePalette()
}

class ImagePickerViewController: UIViewController, UINavigationControllerDelegate, ImagePickerViewControllerDelegate {
    
    var pickedImage: UIImage?
    var scrollView: ImageScrollView?
    var imagePicker: ImagePickerControls?
    var touchX: CGFloat?
    var touchY: CGFloat?
    var color: UIColor?
    let ciContext = CIContext(options: nil)
    var ciImage: CIImage?
    
    let palette = ColorPaletteView()
    
    weak var delegate: ViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        scrollView = ImageScrollView(image: pickedImage!)
        
        scrollView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateTargetIcon)))
        
        // calculate center position for target
        touchX = (self.view.frame.width / 2)
        touchY = (self.view.frame.height / 2)
        
        setupViews()
        
        setupFloaty()
        
        imagePicker = headerContainer
        imagePicker?.delegate = self
        
        palette.delegate2 = self
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
        
        ciImage =  CIImage(cgImage: (pickedImage?.cgImage)!)
        
        generateLivePreview()

    }
    
    let pc = PreviewController()
    
    func openColorsList() {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        navigationController!.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(pc, animated: false)
    }
    
    func closePalette() {
        animate(view: palette, x: 10, y: -150, width: palette.frame.width, height: palette.frame.height)
    }
    
    func animate(view: UIView!, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                view.frame = CGRect(x: x, y: y, width: width, height: height)
        },
            completion: nil
        )
    }
    
    func generateColorPalette(image: UIImage) {
        
        if let window = UIApplication.shared.keyWindow {

            let capturedImageInstance = UIImage(cgImage: (pickedImage?.cgImage)!)
            
            palette.palette = capturedImageInstance.dominantColors(DefaultParameterValues.maxSampledPixels, accuracy: DefaultParameterValues.accuracy, seed: DefaultParameterValues.seed, memoizeConversions: DefaultParameterValues.memoizeConversions)
            
            palette.reloadData()
            palette.frame.origin.y = -150
            
            window.addSubview(palette)
            palette.frame.size.height = 120
            palette.frame.size.width = view.frame.width - 20
            palette.frame.origin.x = 10
            
            animate(view: palette, x: 10, y: 30, width: palette.frame.width, height: palette.frame.height)
        }
        
        
    }
    
    func setupFloaty() {
        let floaty = Floaty()
        floaty.buttonImage = UIImage(named: "settings")
        floaty.paddingX = 30
        floaty.paddingY = 60
        floaty.size = 45
        floaty.autoCloseOnTap = false
        floaty.itemImageColor = UIColor.blue
        floaty.addItem("Color Palette", icon: UIImage(named: "hue"), handler: { item in
            self.generateColorPalette(image: self.pickedImage!)
            floaty.close()
        })
        
        floaty.addItem("Go Back", icon: UIImage(named: "back"), handler: { item in
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            self.navigationController!.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.popViewController(animated: false)
        })
        self.view.addSubview(floaty)
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
        view.addConstraintsWithFormat(format: "V:|[v0]-0-[v1(130)]-(0)-|", views: scrollView!, headerContainer)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView!)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContainer)

//        scrollView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}
