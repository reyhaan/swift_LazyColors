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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        addCameraControls()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    let cameraButton: CameraControlsOverlay = {
        let cb = CameraControlsOverlay()
        return cb
    }()
    
    func addCameraControls () {
        view.addSubview(cameraButton)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: cameraButton)
        view.addConstraintsWithFormat(format: "V:[v0(140)]|", views: cameraButton)
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
