//
//  ViewController.swift
//  LazyColors
//
//  Created by Mohammad Rehaan on 8/6/17.
//  Copyright © 2017 Mohammad Rehaan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var touchX: CGFloat?
    var touchY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        touchX = (self.view.frame.width / 2) - 5
        touchY = (self.view.frame.height / 2) - 5
        
        addCameraControls()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
  
    let cameraButtons: CameraControlsOverlay = {
        let cb = CameraControlsOverlay()
        return cb
    }()
    
    let target: UIView = {
        let tg = UIView()
        tg.backgroundColor = UIColor.white
        tg.frame.size.height = 10
        tg.frame.size.width = 10
        
        return tg
    }()
    
    // captyure touch event on the camera view
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
        target.frame.origin.x = touchX!
        target.frame.origin.y = touchY!
        view.addSubview(target)
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
    
    func startRunningCaptureSession () {
        captureSession.startRunning()
    }
    
    
}
