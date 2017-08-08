//
//  ViewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var outputData: AVCaptureVideoDataOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var touchX: CGFloat?
    var touchY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        // calculate center position for target
        touchX = (self.view.frame.width / 2) - 9
        touchY = (self.view.frame.height / 2) - 9
        
        addCameraControls()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        printDetails()
        startRunningCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool){
        
        //Doesn`t neeed to call super to work
        view.setNeedsLayout()
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
    
    let capturedImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    // capture touch event on the camera view
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: UIView())
        touchX = (location?.x)!
        touchY = (location?.y)!
        target.frame.origin.x = touchX!
        target.frame.origin.y = touchY!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: UIView())
        touchX = (location?.x)!
        touchY = (location?.y)!
        target.frame.origin.x = touchX!
        target.frame.origin.y = touchY!
    }
    
    func addCameraControls () {
        view.addSubview(cameraButtons)
        
        // set target icon here
        targetIcon.frame.size.height = 18
        targetIcon.frame.size.width = 18
        
        // inject target's icon to target view
        target.addSubview(targetIcon)
        
        // set target initial postion
        target.frame.origin.x = touchX!
        target.frame.origin.y = touchY!
        
        view.addSubview(target)
        
        capturedImage.frame.origin.x = 0
        capturedImage.frame.origin.y = 0
        capturedImage.frame.size.height = view.frame.height
        capturedImage.frame.size.width = view.frame.width
//        view.addSubview(capturedImage)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: cameraButtons)
        view.addConstraintsWithFormat(format: "V:[v0(140)]|", views: cameraButtons)
    }
    
    func setupCaptureSession () {
        captureSession.sessionPreset = AVCaptureSessionPreset1920x1080
    }
    
    func setupDevice () {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
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
    
    func getPixelColorAtPoint(point:CGPoint, sourceView: UIView) -> UIColor{
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        sourceView.layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                    green: CGFloat(pixel[1])/255.0,
                                    blue: CGFloat(pixel[2])/255.0,
                                    alpha: CGFloat(pixel[3])/255.0)
        
        pixel.deallocate(capacity: 4)
        return color
    }
    
    func updateColorPreview (color: UIColor) {
        view.subviews[0].subviews[0].backgroundColor = color
        view.subviews[0].subviews[0].setNeedsLayout()
//        let headerCollectionView = controlsHeader
//        
//        let previewCell = headerCollectionView.cellForItem(at: IndexPath(item: 2, section: 1))
//        
//        previewCell?.backgroundColor = color
    }

    @objc func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Do more fancy stuff with sampleBuffer.
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
        let image = UIImage(ciImage: ciImage)
        
        capturedImage.image = image

        let color = capturedImage.getPixelColorAt(point: CGPoint(x: touchX!, y: touchY!))
        updateColorPreview(color: color)
        
        print(color)

    }
    
}
