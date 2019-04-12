//
//  ScannerViewController.swift
//  Pharmagraph
//
//  Created by Cameron McWilliam on 30/08/2018.
//  Copyright © 2018 Cameron McWilliam. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit
import SwiftSocket

var pointNumber: String!
var tagText: String!
var descriptorText: String!
var offsetText: String!
var scaleText: String!

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var codeString: String!
    var defaults = UserDefaults.standard
    var qrCodeFrameView: UIView!
    var blackLeftView: UIView!
    var blackRightView: UIView!
    var blackUpView: UIView!
    var blackDownView: UIView!
    var scannerView: UIView!
    var ip1 : UITextField!
    var ip2 : UITextField!
    var ip3 : UITextField!
    var ip4 : UITextField!
    var port : UITextField!
    var alertFail: UIAlertController!
    var timeout: UInt32!
    var firstFail: Bool!
    var scanRectTransformed: CGRect!
    var scanRectView: CGRect!
    var scanRect: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstFail = true
        timeout = 100000
        let defaults = UserDefaults.standard
        
        let placeholder = NSAttributedString(string: "")
        
        ip1 = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        ip1.keyboardType = UIKeyboardType.numberPad
        ip1.attributedPlaceholder = placeholder
        ip1.textColor = UIColor.black
        ip1.delegate = self
        ip1.borderStyle = UITextField.BorderStyle.roundedRect
        ip1.clearsOnBeginEditing = false
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        
        //Second textfield where user enters IP
        ip2 = UITextField(frame: CGRect(x: 110, y: 100, width: 60, height: 20))
        ip2.keyboardType = UIKeyboardType.numberPad
        ip2.attributedPlaceholder = placeholder
        ip2.textColor = UIColor.black
        ip2.delegate = self
        ip2.borderStyle = UITextField.BorderStyle.roundedRect
        ip2.clearsOnBeginEditing = false
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        
        //Third textfield where user enters IP
        ip3 = UITextField(frame: CGRect(x: 180, y: 100, width: 60, height: 20))
        ip3.keyboardType = UIKeyboardType.numberPad
        ip3.attributedPlaceholder = placeholder
        ip3.textColor = UIColor.black
        ip3.delegate = self
        ip3.borderStyle = UITextField.BorderStyle.roundedRect
        ip3.clearsOnBeginEditing = false
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        
        //Fourth textfield where user enters IP
        ip4 = UITextField(frame: CGRect(x: 250, y: 100, width: 60, height: 20))
        ip4.keyboardType = UIKeyboardType.numberPad
        ip4.attributedPlaceholder = placeholder
        ip4.textColor = UIColor.black
        ip4.delegate = self
        ip4.borderStyle = UITextField.BorderStyle.roundedRect
        ip4.clearsOnBeginEditing = false
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        
        //Textfield where user enters port
        port = UITextField(frame: CGRect(x: 330, y: 100, width: 70, height: 20))
        port.keyboardType = UIKeyboardType.numberPad
        port.attributedPlaceholder = placeholder
        port.textColor = UIColor.black
        port.delegate = self
        port.borderStyle = UITextField.BorderStyle.roundedRect
        port.clearsOnBeginEditing = false
        port.text = defaults.value(forKey: "portText") as? String
        
        alertFail = UIAlertController(title: "Connection Failed", message: "Please check your connection and try again", preferredStyle: .alert)
        alertFail.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        let screenWidth = self.view.frame.size.width
        print(screenWidth)
        print(self.view.frame.size.height)
        print(self.view.bounds.width)
        print(self.view.bounds.height)
        let scanRectPoints = CGRect(x: 0.278, y: 0.387, width: 0.45, height: 0.22)
        scanRect = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1280x720;
        captureSession.startRunning()
        metadataOutput.rectOfInterest = scanRect
        
        scannerView = UIView()
        
        if let scannerView = scannerView {
            //scannerView.frame = CGRect(x: 0.278*375, y: 0.387*812, width: 0.45*375, height: 0.22*812)
            scannerView.frame = CGRect(x: 0.2*1280, y: 0.2*720, width: 0.6*1280, height: 0.62*720)
            scannerView.layer.backgroundColor = UIColor.red.cgColor
            scannerView.layer.opacity = 0.5
            //view.addSubview(scannerView)
            //view.bringSubviewToFront(scannerView)
        }
        
        blackLeftView = UIView()
    
        
        if let blackLeftView = blackLeftView {
            blackLeftView.frame = CGRect(x: 0, y: 0, width: 103, height:  self.view.frame.height)
            blackLeftView.layer.backgroundColor = UIColor.black.cgColor
            blackLeftView.layer.opacity = 0.5
            view.addSubview(blackLeftView)
        }
        
        blackRightView = UIView()
        
        if let blackRightView = blackRightView {
            blackRightView.frame = CGRect(x: 275, y: 0, width: 137.5, height:  self.view.frame.height)
            blackRightView.layer.backgroundColor = UIColor.black.cgColor
            blackRightView.layer.opacity = 0.5
            view.addSubview(blackRightView)
        }
        
        blackUpView = UIView()
        
        if let blackUpView = blackUpView {
            blackUpView.frame = CGRect(x: 103, y: 0, width: 172, height:  313)
            blackUpView.layer.backgroundColor = UIColor.black.cgColor
            blackUpView.layer.opacity = 0.5
            view.addSubview(blackUpView)
        }
        
        blackDownView = UIView()
        
        if let blackDownView = blackDownView {
            blackDownView.frame = CGRect(x: 103, y: 494.5, width: 172, height:  313)
            blackDownView.layer.backgroundColor = UIColor.black.cgColor
            blackDownView.layer.opacity = 0.5
            view.addSubview(blackDownView)
        }
        
        
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.frame = CGRect(x: 0.278*375, y: 0.387*812, width: 0.45*375, height: 0.22*812)

            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        
        

    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.qrCodeFrameView.layer.addSublayer(self.createFrame())
        firstFail = true

        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        let ip1String = self.ip1.text!
        let ip1Num = Int(ip1String)
        let ip2String = self.ip2.text!
        let ip2Num = Int(ip2String)
        let ip3String = self.ip3.text!
        let ip3Num = Int(ip3String)
        let ip4String = self.ip4.text!
        let ip4Num = Int(ip4String)
        let portString = self.port.text!
        let portNum = Int32(portString)
        
        print("\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!) Port: \(portNum!)")
        
        let client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?\"\(code)\r" ) {
            case .success:
                usleep(timeout)
                guard let data = client.read(1024*10) else {
                    client.close()
                    return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    firstFail = false
                    print("Success! point")
                    let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                    let responseString = response[...indexEndOfText]
                    tagText = code
                    pointNumber = String(responseString)
                    
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
        if firstFail == false {
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?D\(pointNumber!)\r" ) {
            case .success:
                usleep(timeout)
                guard let data = client.read(1024*10) else {
                    client.close()
                    return }
                
                if let response = String(bytes: data, encoding: .utf8 ) {
                    print("Success! descriptor")
                    let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                    let responseString = response[...indexEndOfText]
                    print(responseString)
                    descriptorText = String(responseString)
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
        
        
        
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?S\(pointNumber!)\r" ) {
            case .success:
                usleep(timeout)
                guard let data = client.read(1024*10) else {
                    client.close()
                    return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print("Success! scale")
                    let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                    let responseString = response[...indexEndOfText]
                    print(responseString)
                    let responseRaw = Float(responseString)
                    let responseProcessed = responseRaw?.cleanValue
                    let responseProcessedString = String?(responseProcessed!)
                    scaleText = responseProcessedString
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
        
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?O\(pointNumber!)\r" ) {
            case .success:
                usleep(timeout)
                guard let data = client.read(1024*10) else {
                    client.close()
                    return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print("Success!")
                    let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                    let responseString = response[...indexEndOfText]
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    print(responseString)
                    let responseRaw = Float(responseString)
                    let responseProcessed = responseRaw?.cleanValue
                    let responseProcessedString = String?(responseProcessed!)
                    offsetText = responseProcessedString
                    let tabBar = appDelegate.tabBarController
                    tabBar?.selectedIndex = 0
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
           
        
      }
        else {
            descriptorText = ""
            pointNumber = ""
            tagText = ""
            scaleText = ""
            offsetText = ""
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBar = appDelegate.tabBarController
            tabBar?.selectedIndex = 0
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func createFrame() -> CAShapeLayer {
        let height: CGFloat = self.qrCodeFrameView.frame.size.height
        let width: CGFloat = self.qrCodeFrameView.frame.size.width
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 25))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 25, y: 0))
        path.move(to: CGPoint(x: width - 25, y: 0))
        path.addLine(to: CGPoint(x: width - 0, y: 0))
        path.addLine(to: CGPoint(x: width - 0, y: 25))
        path.move(to: CGPoint(x: 0, y: height - 25))
        path.addLine(to: CGPoint(x: 0, y: height - 0))
        path.addLine(to: CGPoint(x: 25, y: height - 0))
        path.move(to: CGPoint(x: width - 25, y: height - 0))
        path.addLine(to: CGPoint(x: width - 0, y: height - 0))
        path.addLine(to: CGPoint(x: width - 0, y: height - 25))
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.lineWidth = 3
        shape.fillColor = UIColor.clear.cgColor
        return shape
    }
    
    
    
}

extension Float
{
    var cleanValue: String
    {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
