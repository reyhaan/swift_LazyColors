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
    
    var ciImage: CIImage?
    var isFlashOn = false
    var isFrameFrozen = false
    let imagePicker = UIImagePickerController()
    
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
        
        // for delegates
        footerCell = cameraButtons.footerContainer
        headerCells = cameraButtons.headerContainer
        headerCells?.delegate = self
        footerCell?.delegate = self
        
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
        target.frame.origin.x = touchX! - 9
        target.frame.origin.y = touchY! - 9
        
        if isFrameFrozen {
            generateLivePreview()
        }
        
        
        view.setNeedsLayout()
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
        view.addConstraintsWithFormat(format: "V:[v0(140)]|", views: cameraButtons)
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
        generateLivePreview()
    }
    
}
