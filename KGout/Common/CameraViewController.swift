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
}


class CameraViewController: GoutDefaultViewController {
    
    let addButton = AddButton()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var session: AVCaptureSession!
    var videoDataOutput: AVCaptureVideoDataOutput!
    var stillImageOutput: AVCaptureStillImageOutput!
    
    var cameraDelegate:CameraDelegate?
    
    lazy var placeHolder: UIView! = {
        return UIView()
    }()
    
    lazy var cameraPermissionInfoLable:UILabel! = {
        let label = UILabel()
        label.text = "asdfs "
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    lazy var captureButton: BaseButton! = {
        var button = BaseButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "captureBtn_nor"), for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "captureBtn_sel"), for: .highlighted)
        return button
    }()
    
    lazy var cancelButton: UIButton! = {
        let button = UIButton()
        button.setTitle(StringConstants.cancelBtn, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(0xAFDFE3)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 8
        
        button.addTarget(self, action: #selector(touchDown), for: .touchDown)
        button.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchDragExit])
        
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
        self.view.addSubview(cameraPermissionInfoLable)
        self.view.addSubview(captureButton)
        
        naviBar.autoPinEdge(toSuperviewEdge: .top, withInset: Constants.statusHeight())
        naviBar.autoPinEdge(toSuperviewEdge: .left)
        naviBar.autoPinEdge(toSuperviewEdge: .right)
        naviBar.autoSetDimension(.height, toSize: 44)
        
        naviBar.title = StringConstants.medicinePhoto
        naviBar.leftButton = cancelButton
        
        placeHolder.backgroundColor = .white
        placeHolder.autoPinEdge(.top, to: .bottom, of: naviBar)
        placeHolder.autoPinEdge(toSuperviewEdge: .left)
        placeHolder.autoSetDimensions(to: CGSize(width:  screenWidth, height: screenWidth))
        
        captureButton.autoPinEdge(.top, to: .bottom, of: placeHolder, withOffset: 20)
        captureButton.autoAlignAxis(toSuperviewAxis: .vertical)
        captureButton.autoSetDimensions(to: CGSize(width: 66, height: 66))
        
        prepareCamera()
        
        cancelButton.rx.tap.bind {
            [weak self] _ in
            self?.dismissSelf(true)
            }.disposed(by: disposeBag)
        
        captureButton.rx.tap.bind {
            [weak self] _ in
            self?.saveToCamera()
            }.disposed(by: disposeBag)
        
    }
    
    func prepareCamera(){        
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSession.Preset.photo//AVCaptureSessionPresetPhoto
        
        checkPermissionCamera()
        updateCameraSelection()
        setupVideoProcession()
        setupCameraPreview()
        
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
    
    /**
     카메라 접근 권한 체크 및 권한에 따른 액션 처리
     */
    func checkPermissionCamera(){
        
        DispatchQueue.main.async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                self.showAlert2(StringConstants.cameraAccessDinied,
                           yes: StringConstants.yesBtn,
                           no: StringConstants.noBtn,
                           nextFunction: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                            },
                           closeFunction: {
                                self.dismissSelf(true)
                            
                })
            case .restricted:
                print("Restricted, device owner must approve")
            case .authorized:
                print("Authorized, proceed")
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { success in
                    //사용자가 명시적으로 접근을 거부한 경우
                    if !success {
                        self.showAlert(StringConstants.cameraPermissionDinied, nextFunction: {
                            self.dismissSelf(true)
                        })
                    }
                }
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
    
    @objc func touchDown(sender:UIButton) {
        sender.backgroundColor = UIColor(0x97C1C4)
    }
    
    @objc func touchUp(sender:UIButton) {
        sender.backgroundColor = UIColor(0xAFDFE3)
    }

}
