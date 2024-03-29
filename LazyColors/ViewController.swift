//
//  ViewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import JavaScriptCore

protocol ViewControllerDelegate: class {
    func toggleFrameFreeze()
    func toggleFlash()
    func openImagePicker()
    func openColorsList()
    func freezeFrame()
    func unfreezeFrame()
    func generateColorPalette(image: CIImage)
    func closePalette()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, ViewControllerDelegate {

    let captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var outputData: AVCaptureVideoDataOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var touchX: CGFloat?
    var touchY: CGFloat?
    var color: UIColor?
    let ciContext = CIContext(options: nil)
    
    // for delegates
    var footerCell: CameraControlsFooter?
    var headerCells: CameraControlsHeader?
    var previewController: PreviewController?
    var imagePickerController: ImagePickerViewController?
    
    var ciImage: CIImage?
    var backupCiImage: CIImage?
    var isFlashOn = false
    var isFrameFrozen = false
    let imagePicker = UIImagePickerController()
    
    let palette = ColorPaletteView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        imagePicker.delegate = self
        
        // calculate center position for target
        touchX = (self.view.frame.width / 2)
        touchY = (self.view.frame.height / 2)
        
        addCameraControls()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        printDetails()
        startRunningCaptureSession()
        
        setupFloaty()
        
        // for delegates
//        footerCell = cameraButtons.footerContainer
        headerCells = cameraButtons.headerContainer
        headerCells?.delegate = self
        footerCell?.delegate = self
        palette.delegate = self
        previewController = PreviewController()
        previewController?.delegate = self
        
        imagePickerController = ImagePickerViewController()
        imagePickerController?.delegate = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        freezeFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        unfreezeFrame()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    let cameraButtons: CameraControlsOverlay = {
        let cb = CameraControlsOverlay()
        return cb
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
    
    // layout captured image on this view, not really add it as a subview
    let capturedImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    func setupFloaty() {
        let floaty = Floaty()
        floaty.buttonImage = UIImage(named: "plus_white")
        floaty.rotationDegrees = 225
        floaty.paddingX = 30
        floaty.paddingY = 60
        floaty.size = 45
        floaty.autoCloseOnTap = false
        floaty.itemImageColor = UIColor.blue
        floaty.buttonColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)  // 85,140,255
        floaty.itemButtonColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
        floaty.addItem("Freeze", icon: UIImage(named: "freeze_white"), handler: { item in
            self.toggleFrameFreeze()
            
            if self.isFrameFrozen {
                item.itemBackgroundColor = UIColor(red: 245/255.0, green: 124/255.0, blue: 0/255.0, alpha: 0.8)
            } else {
                item.itemBackgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
            }
        })
        
        floaty.addItem("Flash", icon: UIImage(named: "flash_white"), handler: { item in
            self.toggleFlash()
            
            if self.isFlashOn {
                item.itemBackgroundColor = UIColor(red: 245/255.0, green: 124/255.0, blue: 0/255.0, alpha: 0.8)
            } else {
                item.itemBackgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.4)
            }
            
        })
        floaty.addItem("Color Palette", icon: UIImage(named: "hue_white"), handler: { item in
            self.generateColorPalette(image: self.backupCiImage!)
            floaty.close()
        })
        floaty.addItem("Select Image", icon: UIImage(named: "select_image_white"), handler: { item in
            self.openImagePicker()
            floaty.close()
        })
        self.view.addSubview(floaty)
    }
    
    // capture touch event on the camera view
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self.view)
        touchX = (location?.x)!
        touchY = (location?.y)!
        target.frame.origin.x = touchX! - 9
        target.frame.origin.y = touchY! - 9
        
        if isFrameFrozen {
            generateLivePreview()
        }
        
        view.setNeedsLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self.view)
        touchX = (location?.x)!
        touchY = (location?.y)!
        
        if touchY! < self.view.frame.height - 90 {
            animate(view: target, x: touchX! - 9, y: touchY! - 9, width: target.frame.width, height: target.frame.height)
            
            if isFrameFrozen {
                generateLivePreview()
            }
            
            
            view.setNeedsLayout()
        }
        
        
    }
    
    func addCameraControls () {
        view.addSubview(cameraButtons)
        
        // set target icon here
        targetIcon.frame.size.height = 18
        targetIcon.frame.size.width = 18
        
        // inject target's icon to target view
        target.addSubview(targetIcon)
        
        // set target initial postion
        target.frame.origin.x = touchX! - 9
        target.frame.origin.y = touchY! - 9
        
        view.addSubview(target)
        
        // setting overlay for pixel calculation
        capturedImage.frame.origin.x = 0
        capturedImage.frame.origin.y = 0
        capturedImage.frame.size.height = view.frame.height
        capturedImage.frame.size.width = view.frame.width
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: cameraButtons)
        view.addConstraintsWithFormat(format: "V:[v0(130)]|", views: cameraButtons)
    }
    
    func setupCaptureSession () {
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
    }
    
    public func toggleFrameFreeze() {
        if isFrameFrozen {
            captureSession.startRunning()
            isFrameFrozen = false
        } else {
            captureSession.stopRunning()
            isFrameFrozen = true
        }
    }
    
    func freezeFrame() {
        isFrameFrozen = true
        captureSession.stopRunning()
    }
    
    func unfreezeFrame() {
        isFrameFrozen = false
        captureSession.startRunning()
    }
    
    func openImagePicker() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
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
    
    func generateColorPalette(image: CIImage) {
        
        if let window = UIApplication.shared.keyWindow {
            
            freezeFrame()
            let capturedImageInstance = getUIImage(image: image)
            
            palette.palette = capturedImageInstance.dominantColors(DefaultParameterValues.maxSampledPixels, accuracy: DefaultParameterValues.accuracy, seed: DefaultParameterValues.seed, memoizeConversions: DefaultParameterValues.memoizeConversions)
            
            palette.reloadData()
            palette.frame.origin.y = -150
            
            window.addSubview(palette)
            palette.frame.size.height = 120
            palette.frame.size.width = view.frame.width - 20
            palette.frame.origin.x = 10
            
            animate(view: palette, x: 10, y: 30, width: palette.frame.width, height: palette.frame.height)
            unfreezeFrame()
        }
        
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let ipvc = ImagePickerViewController()
            
            ipvc.pickedImage = pickedImage
            
            let transition:CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            navigationController!.view.layer.add(transition, forKey: kCATransition)
            
            navigationController?.pushViewController(ipvc, animated: false)

        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
    
    public func toggleFlash() {
        if isFlashOn {
            let devices = deviceDiscoverySession?.devices
            for device in (devices)! {
                if device.hasFlash {
                    do {
                        try device.lockForConfiguration()
                        device.torchMode = AVCaptureTorchMode.off
                    } catch {
                        
                    }
                }
                device.unlockForConfiguration()
            }
            isFlashOn = false
        } else {
            let devices = deviceDiscoverySession?.devices
            for device in (devices)! {
                if device.hasFlash {
                    do {
                        try device.lockForConfiguration()
                        device.torchMode = AVCaptureTorchMode.on
                    } catch {
                        
                    }
                }
                device.unlockForConfiguration()
            }
            isFlashOn = true
        }
    }
    
    func setupDevice () {
        let devices = deviceDiscoverySession?.devices
        for device in (devices)! {
            if device.position == AVCaptureDevicePosition.back {
                backCamera = device
            } else if device.position == AVCaptureDevicePosition.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    func setupInputOutput () {
        do {
            let captureDeviceInput =  try AVCaptureDeviceInput(device: currentCamera)
            captureSession.addInput(captureDeviceInput)
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecJPEG])], completionHandler: nil)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer () {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func printDetails () {
        outputData = AVCaptureVideoDataOutput()
        outputData?.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable:Int(kCVPixelFormatType_32BGRA)]  // kCVPixelFormatType_32BGRA
        
        let captureSessionQueue = DispatchQueue(label: "CameraSessionQueue", attributes: [])
        outputData?.setSampleBufferDelegate(self, queue: captureSessionQueue)
        captureSession.addOutput(outputData)
    }
    
    func startRunningCaptureSession () {
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }

    @objc func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
        backupCiImage = ciImage
        generateLivePreview()
    }
    
}
