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

protocol ViewControllerDelegate: class {
    func toggleFrameFreeze()
    func toggleFlash()
    func openImagePicker()
    func openColorsList()
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, ViewControllerDelegate {
    
    var captureSession = AVCaptureSession()
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
        
        setupData()
        
        footerCell = cameraButtons.footerContainer
        headerCells = cameraButtons.headerContainer
        headerCells?.delegate = self
        footerCell?.delegate = self
        
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
        
        if !captureSession.isRunning {
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
        
        if !captureSession.isRunning {
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
    
    func openImagePicker() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    let pc = PreviewController()
    
    func openColorsList() {
        captureSession.stopRunning()
        navigationController?.pushViewController(pc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            cameraPreviewLayer.contentMode = .ScaleAspectFit
//            cameraPreviewLayer.image = pickedImage
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
    
    func getUIImage(image: CIImage) -> UIImage {
        let image2: CIImage = image
        let image3: CGImage = {
            return ciContext.createCGImage(image2, from: image2.extent)!
        }()
        return UIImage(cgImage: image3)
    }
    
    func applyFilter(image: CIImage, name: String) -> UIImage {
        // 1
        let originalImage = image
        var ouputImage: CIImage?
        
        switch name {
        case "sepia":
            // define filter here
            let filter = CIFilter(name: "CIPhotoEffectMono")
            filter?.setDefaults()
            filter?.setValue(originalImage, forKey: kCIInputImageKey)
            ouputImage = filter?.outputImage
            break
        default:
            // handle default case
            
            break
        }
   
        let newImage = getUIImage(image: ouputImage!)
        
        return newImage
        
    }
    
    func cropImage (image: CIImage, touchX: CGFloat, touchY: CGFloat) -> UIImage {
        let CropBoxHeight = CGFloat(10)
        let CropBoxWidth = CGFloat(10)
        
        // fix orientation of image
        var inputCiImage = image
        inputCiImage = inputCiImage.applyingOrientation(6)

        // actual image size and screen size is different, so scale the touch points to match image size cordinates
        let img = UIImage(ciImage: inputCiImage)
        let scaleFactorY = img.size.height / view.frame.height
        let scaleFactorX = img.size.width / view.frame.width
        
        // apply cropping
        let croppedImage = inputCiImage.cropping(to: CGRect(x: touchX * scaleFactorX, y: ((view.frame.height * scaleFactorY) - (touchY * scaleFactorY)), width: CropBoxWidth, height: CropBoxHeight))
        
        let cgImage = ciContext.createCGImage(croppedImage, from: (croppedImage.extent))
        return UIImage(cgImage: cgImage!)
    }
    
    func updateColorPreview (image: UIImage) {
        let dominantColor = image.dominantColors()
        self.color = dominantColor[0]
        let collectionView = self.cameraButtons.headerContainer.headerCollectionView
        let cell = collectionView.cellForItem(at: IndexPath(item: 1, section: 0))
        
        let colorNameView = self.cameraButtons.colorNameContainer
        
        DispatchQueue.main.async() {
//            colorNameView.name.text = self.color?.getName()[1] as? String
//            colorNameView.code.font = UIFont(name: "ProximaNovaRegular", size: 5)
            colorNameView.code.text = "#" + (self.color?.getHex())!
        }
        

        
        cell?.subviews[1].backgroundColor = self.color
        cell?.subviews[1].setNeedsLayout()
    }
    
    func generateLivePreview() {
        // update UI asynchronously
        DispatchQueue.main.async() {
            // Apply filter to crop it here
            let image = self.cropImage(image: self.ciImage!, touchX: self.touchX!, touchY: self.touchY!)
            self.updateColorPreview(image: image)
        }
    }

    @objc func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
        generateLivePreview()
    }
    
}
