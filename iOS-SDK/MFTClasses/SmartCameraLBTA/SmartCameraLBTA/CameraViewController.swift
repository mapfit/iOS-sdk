//
//  ViewController.swift
//  SmartCameraLBTA
//
//  Created by Zain N. on 7/17/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import AVKit
import Vision
import CoreML
import SceneKit
import ARKit
import CoreLocation


class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, ARSCNViewDelegate, ARSessionDelegate{
    
    
    lazy var classificationText: UILabel = UILabel()
    lazy var cameraView: UIView = UIView()
    private lazy var classifier: ImageClassifier = ImageClassifier()
    lazy var analyzedImageView: UIImageView = UIImageView()
    lazy var originalImageView: UIImageView = UIImageView()
    private var lastObservation: VNDetectedObjectObservation?
    private let visionSequenceHandler = VNSequenceRequestHandler()
    
    
    private var requests = [VNRequest]()
    
    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    // Create an AVCaptureSession
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else { return session }
        session.addInput(input)
        return session
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(cameraView)
        cameraView.frame = view.bounds
        cameraView.layer.addSublayer(cameraLayer)
        cameraLayer.frame = cameraView.bounds
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
        setUpClassificationText()
        
        
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Camera was able to capture a frame:", Date())
        
        
        guard let pixelBuffer: CVPixelBuffer = sampleBuffer.imageBuffer else { return }
        
        guard let model = try? VNCoreMLModel(for: classifier.model) else { return }
        
       let request = VNCoreMLRequest(model:  model) { (finishedReq, error) in

            //print(finishedReq.results)

            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }

            guard let firstObservation = results.first else { return }

            DispatchQueue.main.async {
                self.classificationText.text = "\(firstObservation.identifier)" + " \(firstObservation.confidence)"
                

            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        request.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
        
        
       
        
        
        
    }
    
    func setUpClassificationText(){
        
        classificationText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(classificationText)
        
        classificationText.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        classificationText.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        classificationText.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2).isActive = true
        classificationText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
    }
    
    
    func transformRect(fromRect: CGRect , toViewRect :UIView) -> CGRect {
        
        var toRect = CGRect()
        toRect.size.width = fromRect.size.width * toViewRect.frame.size.width
        toRect.size.height = fromRect.size.height * toViewRect.frame.size.height
        toRect.origin.y =  (toViewRect.frame.height) - (toViewRect.frame.height * fromRect.origin.y )
        toRect.origin.y  = toRect.origin.y -  toRect.size.height
        toRect.origin.x =  fromRect.origin.x * toViewRect.frame.size.width
        
        return toRect
    }
    
    func CreateBoxView(withColor : UIColor) -> UIView {
        let view = UIView()
        view.layer.borderColor = withColor.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = UIColor.clear
        return view
    }

}

