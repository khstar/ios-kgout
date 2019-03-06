//
//  CameraViewController.swift
//  Gout
//
//  Created by khstar on 24/10/2018.
//  Copyright © 2018 khstar. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraDelegate{
    func capture(image: UIImage)
//    func close()
//    func change()
}


class CameraViewController: GoutDefaultViewController {
    
    let addButton = AddButton()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var session: AVCaptureSession!
    var videoDataOutput: AVCaptureVideoDataOutput!
    var stillImageOutput: AVCaptureStillImageOutput!
//    lazy var naviBar: BaseNaviBar! = {
//        return BaseNaviBar()
//    }()
    
    var cameraDelegate:CameraDelegate?
    
    lazy var placeHolder: UIView! = {
        return UIView()
    }()
    
    lazy var captureButton: BaseButton! = {
        var button = BaseButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "captureBtn_nor"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "captureBtn_sel"), for: .highlighted)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        session.startRunning()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        session.stopRunning()
    }
    
    func setupView() {
        self.view.addSubview(naviBar)
        self.view.addSubview(placeHolder)
        self.view.addSubview(captureButton)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = "약품 정보"
        naviBar.rightButton = addButton
        
        placeHolder.backgroundColor = .green
        placeHolder.autoPinEdge(.top, to: .bottom, of: naviBar)
        placeHolder.autoPinEdge(toSuperviewEdge: .left)
        placeHolder.autoSetDimensions(to: CGSize(width:  screenWidth, height: screenWidth))
        
        captureButton.autoPinEdge(.top, to: .bottom, of: placeHolder, withOffset: 20)
        captureButton.autoAlignAxis(toSuperviewAxis: .vertical)
        captureButton.autoSetDimensions(to: CGSize(width: 66, height: 66))
        
//        setupCameraPreview()
//        self.session = AVCaptureSession()
        prepareCamera()
//        updateCameraSelection()
//        checkPermissionCamera()
        
        addButton.rx.tap.bind {
            [weak self] _ in
//            self?.naviPopViewController(animated: true)
            self?.dismissSelf(true)
        }.disposed(by: disposeBag)
        
        captureButton.rx.tap.bind {
            [weak self] _ in
            //            self?.naviPopViewController(animated: true)
            self?.saveToCamera()
            }.disposed(by: disposeBag)
        
    }
    
    func prepareCamera(){
        
        self.session = AVCaptureSession()
       self.session.sessionPreset = AVCaptureSession.Preset.photo//AVCaptureSessionPresetPhoto
        
        updateCameraSelection()
        setupVideoProcession()
        setupCameraPreview()
        //        Utils.saveDetectXmlFromBundle()
        
    }
    
    func setupVideoProcession() {
        videoDataOutput = AVCaptureVideoDataOutput()
        let rgbOutputSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA]
        
        videoDataOutput.videoSettings = rgbOutputSettings as! [String : Any]
        
        if !self.session.canAddOutput(videoDataOutput) {
            self.setupVideoProcession()
            return
        }
        
        
        stillImageOutput = AVCaptureStillImageOutput()
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if session.canAddOutput(stillImageOutput) {
            session.addOutput(stillImageOutput)
        }
        
    }
    
    func checkPermissionCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video){ [weak self] response in
            if response{
                print("response")
                self?.setupCameraPreview()
            } else {
                print("else")
//                self?.deniedAuthorize(isCamera: true)
            }
        }
    }
    
    func setupCameraPreview(){
        
//        previewLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
//        session.startRunning()
        
//        self.session = AVCaptureSession()
//        self.session.sessionPreset = AVCaptureSession.Preset.photo//AVCaptureSessionPresetPhoto
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
//        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
//        session.startRunning()
        //        self.previewLayer.backgroundColor = UIColor..cgColor
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill//AVLayerVideoGravityResizeAspect
        let rootLayer = self.placeHolder.layer
        rootLayer.masksToBounds = true
        self.previewLayer.frame = rootLayer.bounds
        
        rootLayer.addSublayer(self.previewLayer)
        
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
//        session.startRunning()
    }
    
    func updateCameraSelection(){
//        self.isFrontCam = !self.isFrontCam
        self.session.beginConfiguration()
        
        let oldInputs = self.session.inputs
        for oldInput in oldInputs {
            self.session.removeInput(oldInput )
        }
        
        let desiredPosition:AVCaptureDevice.Position  = .back
        
        
        if let input = self.cameraForPosition(position: desiredPosition){
            
            self.session.addInput(input)
        } else {
            for oldInput in oldInputs {
                self.session.addInput(oldInput )
            }
        }
        
        
        self.session.commitConfiguration()
    }
    
    func cameraForPosition(position: AVCaptureDevice.Position) -> AVCaptureDeviceInput? {
        for device in AVCaptureDevice.devices(for: AVMediaType.video) {
            if device.position == position {
                do{
                    let input = try AVCaptureDeviceInput.init(device: device)
                    if self.session.canAddInput(input) {
                        return input
                    }
                }catch{
                    
                    return nil
                }
            }
        }
        return nil
    }
    
    func saveToCamera() {
        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
            videoConnection.isVideoMirrored = false
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) { [weak self]
                (imageDataSampleBuffer, error) -> Void in
                
                if error != nil { return }
                
                guard let weakSelf = self else { return }
                
                weakSelf.session.stopRunning()
                
                guard let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer!) else { return }
                
                if let image = UIImage(data: imageData) {
                    
                    let i = image.fixOrientation()
                    print("image")
                    weakSelf.cameraDelegate?.capture(image: i)
                    weakSelf.dismiss(animated: true)
//                    weakSelf.delegate?.capture(image: image)
//                    weakSelf.resetTimer()
//
//                    //사진 처리가 완료된 경우 비활성화 했던 캡쳐 이미지 카운터 이미지 원상태로 돌리기
//                    weakSelf.captureButton.isEnabled = true
//                    weakSelf.captureButton.isHighlighted = true
//                    weakSelf.countImage.isHidden = false
//
//                    //                    weakSelf.capturedImage = image
//                    //
//                    //                    weakSelf.cropBaseOnNose(image)
//                    //
//                    //                    weakSelf.resetTimer()
//                    //                    weakSelf.presentResultVC()
                }
                
            }
        }
    }

}
