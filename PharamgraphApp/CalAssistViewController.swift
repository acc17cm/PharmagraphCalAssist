//
//  CalAssistViewController.swift
//  Pods-Pharmagraph
//
//  Created by Cameron McWilliam on 04/09/2018.
//

import Foundation
import UIKit
import SwiftSocket
import SQLite

class CalAssistViewController: UIViewController, UITextFieldDelegate {
    
    var ip1: UITextField!
    var ip2: UITextField!
    var ip3: UITextField!
    var ip4: UITextField!
    var port: UITextField!
    var point: String!
    var descriptionLabel: UILabel!
    var descriptionData: UILabel!
    var calibrationPoint: UILabel!
    var calibrationPointData: UILabel!
    var tag: UILabel!
    var tagData: UILabel!
    var initialScale: UILabel!
    var initialScaleData: UILabel!
    var offset: UILabel!
    var offsetData: UILabel!
    var calibrationButton: UIButton!
    var alarmsSwitch: UISwitch!
    var state: Bool!
    var calibrationState: Bool!
    var alarmsText: UILabel!
    var calibratedValues: UILabel!
    var inputValues: UILabel!
    var calibrationValue1: UILabel!
    var calibrationValue2: UILabel!
    var calibrationValue1Entry: UITextField!
    var calibrationValue2Entry: UITextField!
    var captureInput1: UIButton!
    var captureInput2: UIButton!
    var arrow1: UILabel!
    var arrow2: UILabel!
    var inputValue1: UITextField!
    var inputValue2: UITextField!
    var finalCalibrationValues: UILabel!
    var finalScale: UILabel!
    var finalScaleData: UILabel!
    var finalOffset: UILabel!
    var finalOffsetData: UILabel!
    var calculateButton: UIButton!
    var defaults = UserDefaults.standard
    var ip1String: String!
    var ip1Num: Int!
    var ip2String: String!
    var ip2Num: Int!
    var ip3String: String!
    var ip3Num: Int!
    var ip4String: String!
    var ip4Num: Int!
    var portString: String!
    var portNum: Int32!
    var client: TCPClient!
    var y1: Float!
    var y2: Float!
    var offsetNum: Float!
    var scaleNum: Float!
    var alertFailConnect: UIAlertController!
    var alertFailQuery: UIAlertController!
    var generator: UIImpactFeedbackGenerator!
    var alarmConnect: Bool!
    var timeout: UInt32!
    var customerText: UILabel!
    var siteText: UILabel!
    var systemText: UILabel!
    
    override func viewDidLoad() {
        
        state = false
        alarmConnect = false
        point = pointNumber
        calibrationState = false
        
        timeout = 200000
        generator = UIImpactFeedbackGenerator(style: .heavy)
        
        view.backgroundColor = UIColor.white
        
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
        if ip2.text == nil {
            defaults.set("\u{200B}", forKey: "ip2Text")
            ip2.text = defaults.value(forKey: "ip2Text") as? String
        }
        else {
        }
        
        //Third textfield where user enters IP
        ip3 = UITextField(frame: CGRect(x: 180, y: 100, width: 60, height: 20))
        ip3.keyboardType = UIKeyboardType.numberPad
        ip3.attributedPlaceholder = placeholder
        ip3.textColor = UIColor.black
        ip3.delegate = self
        ip3.borderStyle = UITextField.BorderStyle.roundedRect
        ip3.clearsOnBeginEditing = false
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        if ip3.text == nil {
            defaults.set("\u{200B}", forKey: "ip3Text")
            ip3.text = defaults.value(forKey: "ip3Text") as? String
        }
        else {
        }
        
        //Fourth textfield where user enters IP
        ip4 = UITextField(frame: CGRect(x: 250, y: 100, width: 60, height: 20))
        ip4.keyboardType = UIKeyboardType.numberPad
        ip4.attributedPlaceholder = placeholder
        ip4.textColor = UIColor.black
        ip4.delegate = self
        ip4.borderStyle = UITextField.BorderStyle.roundedRect
        ip4.clearsOnBeginEditing = false
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        if ip4.text == nil {
            defaults.set("\u{200B}", forKey: "ip4Text")
            ip4.text = defaults.value(forKey: "ip4Text") as? String
        }
        else {
        }
        
        //Textfield where user enters port
        port = UITextField(frame: CGRect(x: 330, y: 100, width: 70, height: 20))
        port.keyboardType = UIKeyboardType.numberPad
        port.attributedPlaceholder = placeholder
        port.textColor = UIColor.black
        port.delegate = self
        port.borderStyle = UITextField.BorderStyle.roundedRect
        port.clearsOnBeginEditing = false
        port.text = defaults.value(forKey: "portText") as? String
        if port.text == nil {
            defaults.set("\u{200B}", forKey: "portText")
            port.text = defaults.value(forKey: "portText") as? String
        }
        else {
        }
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 6, y: 70, width: 363, height: 80), cornerRadius: 20).cgPath
        layer.fillColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(layer)
        
        customerText = UILabel()
        customerText.text = customerName
        customerText.sizeToFit()
        customerText.adjustsFontSizeToFitWidth = true;
        customerText.textAlignment = .left
        customerText.minimumScaleFactor = 10.0
        customerText.frame = CGRect(x: view.bounds.width/2-172, y: view.bounds.height/2-277, width: 300, height: 60)
        view.addSubview(customerText)
        
        siteText = UILabel()
        siteText.text = siteName
        siteText.sizeToFit()
        siteText.adjustsFontSizeToFitWidth = true;
        siteText.textAlignment = .left
        siteText.minimumScaleFactor = 10.0
        siteText.frame = CGRect(x: view.bounds.width/2-172, y: view.bounds.height/2-253, width: 300, height: 60)
        view.addSubview(siteText)
        
        systemText = UILabel()
        systemText.text = systemName
        systemText.sizeToFit()
        systemText.adjustsFontSizeToFitWidth = true;
        systemText.textAlignment = .left
        systemText.minimumScaleFactor = 10.0
        systemText.frame = CGRect(x: view.bounds.width/2-172, y: view.bounds.height/2-228, width: 300, height: 60)
        view.addSubview(systemText)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = "Descriptor:"
        descriptionLabel.sizeToFit()
        descriptionLabel.adjustsFontSizeToFitWidth = true;
        descriptionLabel.textAlignment = .center
        descriptionLabel.minimumScaleFactor = 10.0
        descriptionLabel.frame = CGRect(x: view.bounds.width/2-275, y: view.bounds.height/2-195, width: 300, height: 60)
        view.addSubview(descriptionLabel)
        
        descriptionData = UILabel()
        descriptionData.text = descriptorText
        descriptionData.sizeToFit()
        descriptionData.adjustsFontSizeToFitWidth = true;
        descriptionData.textAlignment = .left
        descriptionData.minimumScaleFactor = 10.0
        descriptionData.frame = CGRect(x: view.bounds.width/2-70, y: view.bounds.height/2-195, width: 300, height: 60)
        view.addSubview(descriptionData)
        
        calibrationPoint = UILabel()
        calibrationPoint.text = "Calibration Point:"
        calibrationPoint.sizeToFit()
        calibrationPoint.adjustsFontSizeToFitWidth = true;
        calibrationPoint.textAlignment = .center
        calibrationPoint.minimumScaleFactor = 10.0
        calibrationPoint.frame = CGRect(x: view.bounds.width/2-255, y: view.bounds.height/2-160, width: 300, height: 60)
        view.addSubview(calibrationPoint)
        
        calibrationPointData = UILabel()
        calibrationPointData.text = pointNumber
        calibrationPointData.sizeToFit()
        calibrationPointData.adjustsFontSizeToFitWidth = true;
        calibrationPointData.textAlignment = .center
        calibrationPointData.minimumScaleFactor = 10.0
        calibrationPointData.frame = CGRect(x: view.bounds.width/2-155, y: view.bounds.height/2-160, width: 300, height: 60)
        view.addSubview(calibrationPointData)
        
        tag = UILabel()
        tag.text = "Tag:"
        tag.sizeToFit()
        tag.adjustsFontSizeToFitWidth = true;
        tag.textAlignment = .center
        tag.minimumScaleFactor = 10.0
        tag.frame = CGRect(x: view.bounds.width/2-95, y: view.bounds.height/2-160, width: 300, height: 60)
        view.addSubview(tag)
        
        tagData = UILabel()
        tagData.text = tagText
        tagData.sizeToFit()
        tagData.adjustsFontSizeToFitWidth = true;
        tagData.textAlignment = .center
        tagData.minimumScaleFactor = 10.0
        tagData.frame = CGRect(x: view.bounds.width/2-40, y: view.bounds.height/2-160, width: 300, height: 60)
        view.addSubview(tagData)

        
        initialScale = UILabel()
        initialScale.text = "Inital Scale:"
        initialScale.sizeToFit()
        initialScale.adjustsFontSizeToFitWidth = true;
        initialScale.textAlignment = .center
        initialScale.minimumScaleFactor = 10.0
        initialScale.frame = CGRect(x: view.bounds.width/2-274, y: view.bounds.height/2-120, width: 300, height: 60)
        view.addSubview(initialScale)
        
        initialScaleData = UILabel()
        initialScaleData.text = scaleText
        initialScaleData.sizeToFit()
        initialScaleData.adjustsFontSizeToFitWidth = true;
        initialScaleData.textAlignment = .center
        initialScaleData.minimumScaleFactor = 10.0
        initialScaleData.frame = CGRect(x: view.bounds.width/2-180, y: view.bounds.height/2-120, width: 300, height: 60)
        view.addSubview(initialScaleData)
        
        offset = UILabel()
        offset.text = "Offset:"
        offset.sizeToFit()
        offset.adjustsFontSizeToFitWidth = true;
        offset.textAlignment = .center
        offset.minimumScaleFactor = 10.0
        offset.frame = CGRect(x: view.bounds.width/2-95, y: view.bounds.height/2-120, width: 300, height: 60)
        view.addSubview(offset)
        
        offsetData = UILabel()
        offsetData.text = offsetText
        offsetData.sizeToFit()
        offsetData.adjustsFontSizeToFitWidth = true;
        offsetData.textAlignment = .center
        offsetData.minimumScaleFactor = 10.0
        offsetData.frame = CGRect(x: view.bounds.width/2-20, y: view.bounds.height/2-120, width: 300, height: 60)
        view.addSubview(offsetData)
        
        calibrationButton = UIButton(frame: CGRect(x: view.bounds.width/2-168, y: view.bounds.height/2-70, width: 100, height: 30))
        calibrationButton.backgroundColor = .clear
        calibrationButton.showsTouchWhenHighlighted = true
        calibrationButton.layer.cornerRadius = 5
        calibrationButton.layer.borderWidth = 1
        calibrationButton.layer.borderWidth = 1
        calibrationButton.layer.borderColor = UIColor.gray.cgColor
        calibrationButton.setTitleColor(UIColor.darkGray, for: .normal)
        calibrationButton.setTitle("Calibrate", for: .normal)
        calibrationButton.addTarget(self, action: #selector(beginCalibration), for: .touchUpInside)
        self.view.addSubview(calibrationButton)
        
        alarmsText = UILabel()
        alarmsText.text = "Inhibit Alarms during cal:"
        alarmsText.sizeToFit()
        alarmsText.adjustsFontSizeToFitWidth = true;
        alarmsText.textAlignment = .left
        alarmsText.frame = CGRect(x: view.bounds.width/2-50, y: view.bounds.height/2-85, width: 150, height: 60)
        view.addSubview(alarmsText)
    
        alarmsSwitch = UISwitch(frame: CGRect(x: view.bounds.width/2+105, y: view.bounds.height/2-70, width: 100, height: 20))
        alarmsSwitch.addTarget(self, action: #selector(stateChanged), for: .touchUpInside)
        self.view.addSubview(alarmsSwitch)
        
        calibratedValues = UILabel()
        calibratedValues.text = "Calibrator Values"
        calibratedValues.sizeToFit()
        calibratedValues.adjustsFontSizeToFitWidth = true;
        calibratedValues.textAlignment = .center
        calibratedValues.frame = CGRect(x: view.bounds.width/2-140, y: view.bounds.height/2-50, width: 100, height: 60)
        view.addSubview(calibratedValues)
        
        calibrationValue1 = UILabel()
        calibrationValue1.text = "Value 1"
        calibrationValue1.sizeToFit()
        calibrationValue1.adjustsFontSizeToFitWidth = true;
        calibrationValue1.textAlignment = .center
        calibrationValue1.frame = CGRect(x: view.bounds.width/2-170, y: view.bounds.height/2-10, width: 40, height: 60)
        view.addSubview(calibrationValue1)
        
        calibrationValue2 = UILabel()
        calibrationValue2.text = "Value 2"
        calibrationValue2.sizeToFit()
        calibrationValue2.adjustsFontSizeToFitWidth = true;
        calibrationValue2.textAlignment = .center
        calibrationValue2.frame = CGRect(x: view.bounds.width/2-170, y: view.bounds.height/2+60, width: 40, height: 60)
        view.addSubview(calibrationValue2)
        
        calibrationValue1Entry = UITextField(frame: CGRect(x: view.bounds.width/2-120, y: view.bounds.height/2+10, width: 60, height: 20))
        calibrationValue1Entry.keyboardType = UIKeyboardType.numbersAndPunctuation
        calibrationValue1Entry.attributedPlaceholder = placeholder
        calibrationValue1Entry.textColor = UIColor.black
        calibrationValue1Entry.backgroundColor = .gray
        calibrationValue1Entry.delegate = self
        calibrationValue1Entry.borderStyle = UITextField.BorderStyle.roundedRect
        calibrationValue1Entry.clearsOnBeginEditing = false
        calibrationValue1Entry.isUserInteractionEnabled = false
        calibrationValue1Entry.addDoneButtonToKeyboard(myAction:  #selector(self.captureInput1.resignFirstResponder))
        view.addSubview(calibrationValue1Entry)
        
        calibrationValue2Entry = UITextField(frame: CGRect(x: view.bounds.width/2-120, y: view.bounds.height/2+80, width: 60, height: 20))
        calibrationValue2Entry.keyboardType = UIKeyboardType.numbersAndPunctuation
        calibrationValue2Entry.attributedPlaceholder = placeholder
        calibrationValue2Entry.textColor = UIColor.black
        calibrationValue2Entry.backgroundColor = .gray
        calibrationValue2Entry.delegate = self
        calibrationValue2Entry.borderStyle = UITextField.BorderStyle.roundedRect
        calibrationValue2Entry.isUserInteractionEnabled = false
        calibrationValue2Entry.clearsOnBeginEditing = false
        calibrationValue2Entry.addDoneButtonToKeyboard(myAction:  #selector(self.calibrationValue2Entry.resignFirstResponder))
        view.addSubview(calibrationValue2Entry)
        
        inputValues = UILabel()
        inputValues.text = "Input Values"
        inputValues.sizeToFit()
        inputValues.adjustsFontSizeToFitWidth = true;
        inputValues.textAlignment = .center
        inputValues.frame = CGRect(x: view.bounds.width/2+70, y: view.bounds.height/2-50, width: 70, height: 60)
        view.addSubview(inputValues)
        
        captureInput1 = UIButton(frame: CGRect(x: view.bounds.width/2-52, y: view.bounds.height/2+5, width: 75, height: 30))
        captureInput1.backgroundColor = .clear
        captureInput1.layer.cornerRadius = 5
        captureInput1.layer.borderWidth = 1
        captureInput1.layer.borderWidth = 1
        captureInput1.layer.borderColor = UIColor.gray.cgColor
        captureInput1.setTitleColor(UIColor.darkGray, for: .normal)
        captureInput1.setTitle("Capture", for: .normal)
        captureInput1.addTarget(self, action: #selector(calibrationAction), for: .touchUpInside)
        self.view.addSubview(captureInput1)
        
        captureInput2 = UIButton(frame: CGRect(x: view.bounds.width/2-52, y: view.bounds.height/2+75, width: 75, height: 30))
        captureInput2.backgroundColor = .clear
        captureInput2.layer.cornerRadius = 5
        captureInput2.layer.borderWidth = 1
        captureInput2.layer.borderWidth = 1
        captureInput2.layer.borderColor = UIColor.gray.cgColor
        captureInput2.setTitleColor(UIColor.darkGray, for: .normal)
        captureInput2.setTitle("Capture", for: .normal)
        captureInput2.addTarget(self, action: #selector(calibrationAction2), for: .touchUpInside)
        self.view.addSubview(captureInput2)
        
        arrow1 = UILabel()
        arrow1.text = "->"
        arrow1.sizeToFit()
        arrow1.adjustsFontSizeToFitWidth = true;
        arrow1.textAlignment = .center
        arrow1.frame = CGRect(x: view.bounds.width/2+30, y: view.bounds.height/2-10, width: 15, height: 60)
        view.addSubview(arrow1)
        
        arrow2 = UILabel()
        arrow2.text = "->"
        arrow2.sizeToFit()
        arrow2.adjustsFontSizeToFitWidth = true;
        arrow2.textAlignment = .center
        arrow2.frame = CGRect(x: view.bounds.width/2+30, y: view.bounds.height/2+60, width: 15, height: 60)
        view.addSubview(arrow2)
        
        inputValue1 = UITextField(frame: CGRect(x: view.bounds.width/2+50, y: view.bounds.height/2+10, width: 120, height: 20))
        inputValue1.keyboardType = UIKeyboardType.numbersAndPunctuation
        inputValue1.attributedPlaceholder = placeholder
        inputValue1.textColor = UIColor.black
        inputValue1.delegate = self
        inputValue1.borderStyle = UITextField.BorderStyle.roundedRect
        inputValue1.clearsOnBeginEditing = false
        inputValue1.isUserInteractionEnabled = false
        view.addSubview(inputValue1)
        
        inputValue2 = UITextField(frame: CGRect(x: view.bounds.width/2+50, y: view.bounds.height/2+80, width: 120, height: 20))
        inputValue2.keyboardType = UIKeyboardType.numbersAndPunctuation
        inputValue2.attributedPlaceholder = placeholder
        inputValue2.textColor = UIColor.black
        inputValue2.delegate = self
        inputValue2.borderStyle = UITextField.BorderStyle.roundedRect
        inputValue2.clearsOnBeginEditing = false
        inputValue2.isUserInteractionEnabled = false
        view.addSubview(inputValue2)
        
        finalCalibrationValues = UILabel()
        finalCalibrationValues.text = "Calibration Values"
        finalCalibrationValues.sizeToFit()
        finalCalibrationValues.adjustsFontSizeToFitWidth = true;
        finalCalibrationValues.textAlignment = .center
        finalCalibrationValues.frame = CGRect(x: view.bounds.width/2-190, y: view.bounds.height/2+140, width: 200, height: 20)
        view.addSubview(finalCalibrationValues)
        
        finalScale = UILabel()
        finalScale.text = "Scale:"
        finalScale.sizeToFit()
        finalScale.adjustsFontSizeToFitWidth = true;
        finalScale.textAlignment = .center
        finalScale.frame = CGRect(x: view.bounds.width/2-208, y: view.bounds.height/2+190, width: 150, height: 20)
        view.addSubview(finalScale)
        
        finalScaleData = UILabel()
        finalScaleData.text = ""
        finalScaleData.sizeToFit()
        finalScaleData.adjustsFontSizeToFitWidth = true;
        finalScaleData.textAlignment = .left
        finalScaleData.frame = CGRect(x: view.bounds.width/2-70, y: view.bounds.height/2+190, width: 150, height: 20)
        view.addSubview(finalScaleData)
        
        finalOffset = UILabel()
        finalOffset.text = "Offset:"
        finalOffset.sizeToFit()
        finalOffset.adjustsFontSizeToFitWidth = true;
        finalOffset.textAlignment = .center
        finalOffset.frame = CGRect(x: view.bounds.width/2-197, y: view.bounds.height/2+240, width: 130, height: 20)
        view.addSubview(finalOffset)
        
        finalOffsetData = UILabel()
        finalOffsetData.text = ""
        finalOffsetData.sizeToFit()
        finalOffsetData.adjustsFontSizeToFitWidth = true;
        finalOffsetData.textAlignment = .left
        finalOffsetData.frame = CGRect(x: view.bounds.width/2-70, y: view.bounds.height/2+240, width: 150, height: 20)
        view.addSubview(finalOffsetData)
        
        calculateButton = UIButton(frame: CGRect(x: view.bounds.width/2+50, y: view.bounds.height/2+135, width: 100, height: 30))
        calculateButton.backgroundColor = .clear
        calculateButton.showsTouchWhenHighlighted = true
        calculateButton.layer.cornerRadius = 5
        calculateButton.layer.borderWidth = 1
        calculateButton.layer.borderWidth = 1
        calculateButton.layer.borderColor = UIColor.gray.cgColor
        calculateButton.setTitleColor(UIColor.darkGray, for: .normal)
        calculateButton.addTarget(self, action: #selector(calculate), for: .touchUpInside)
        calculateButton.setTitle("Calculate", for: .normal)
        
        self.view.addSubview(calculateButton)
        
        
        
        
        alertFailQuery = UIAlertController(title: "Connection Failed", message: "Please check your connection and try again", preferredStyle: .alert)
        alertFailQuery.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        alertFailConnect = UIAlertController(title: "Connection Failed", message: "Please check your connection and try again", preferredStyle: .alert)
        alertFailConnect.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    
    }
    
    @objc func calibrationAction(sender: UIButton) {
        
     
        
        if calibrationValue1Entry.isUserInteractionEnabled == false || pointNumber == nil {
            
        }
        
        else {
            
           generator.impactOccurred()
            ip1String = self.ip1.text!
            ip1Num = Int(ip1String)
            ip2String = self.ip2.text!
            let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
            ip2Num = Int(ip2String[indexStartOfText...])
            ip3String = self.ip3.text!
            ip3Num = Int(ip3String[indexStartOfText...])
            ip4String = self.ip4.text!
            ip4Num = Int(ip4String[indexStartOfText...])
            portString = self.port.text!
            portNum = Int32(portString[indexStartOfText...])
            client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
            print("Connecting")
            print(point!)
            
           switch client.connect(timeout: 1) {
            case .success:
                switch client.send(string: "?V\(point!)\r" ) {
                case .success:
                    usleep(timeout)
                    guard let data = client.read(1024*10) else {
                        client.close()
                        return }
                    
                    if let response = String(bytes: data, encoding: .utf8) {
                        
                        
                        let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                        let responseString = response[...indexEndOfText]
                        let responseRaw = Float(responseString)
                        let responseProcessed = responseRaw?.cleanValue
                        let responseProcessedString = String?(responseProcessed!)
                        inputValue1.text = responseProcessedString
                        let inputValue1Num = Float(inputValue1.text!)
                        offsetNum = Float(offsetData.text!)
                        scaleNum = Float(initialScaleData.text!)
                            if offsetNum == 0 && scaleNum == 0 {
                                
                                y1 = Float(responseProcessedString!)
                                
                            }
                            
                            else if offsetNum != 0 && scaleNum == 0 {
                                
                                y1 = (inputValue1Num!-offsetNum!)/1
                                print(y1)
                                inputValue2.text = y1.cleanValue
                                
                            }
                            
                            else {
                            
                        y1 = (inputValue1Num!-offsetNum!)/scaleNum!
                        print(y1)
                        inputValue1.text = y1.cleanValue
                            }
                        
                    }
                case .failure(let error):
                    print(error)
                    self.present(alertFailQuery, animated: true)
                }
            case .failure(let error):
                print(error)
                print ("Connection failure connecting to ip")
                self.present(alertFailConnect, animated: true)
            }
             client.close()
        }
            
    }
    
    @objc func calibrationAction2(sender: UIButton) {
        
        
        
        if calibrationValue2Entry.isUserInteractionEnabled == false || pointNumber == nil {
            
        }
            
        else {
            generator.impactOccurred()
            print("Connecting")
            print(point!)
            ip1String = self.ip1.text!
            ip1Num = Int(ip1String)
            ip2String = self.ip2.text!
            let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
            ip2Num = Int(ip2String[indexStartOfText...])
            ip3String = self.ip3.text!
            ip3Num = Int(ip3String[indexStartOfText...])
            ip4String = self.ip4.text!
            ip4Num = Int(ip4String[indexStartOfText...])
            portString = self.port.text!
            portNum = Int32(portString[indexStartOfText...])
            client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
            switch client.connect(timeout: 1) {
            case .success:
                switch client.send(string: "?V\(point!)\r" ) {
                case .success:
                    usleep(timeout)
                    guard let data = client.read(1024*10) else {
                        client.close()
                        return }
                    
                    if let response = String(bytes: data, encoding: .utf8) {
                        
                        let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                        let responseString = response[...indexEndOfText]
                        let responseRaw = Float(responseString)
                        let responseProcessed = responseRaw?.cleanValue
                        let responseProcessedString = String?(responseProcessed!)
                        inputValue2.text = responseProcessedString
                        let inputValue2Num = Float(inputValue2.text!)
                        offsetNum = Float(offsetData.text!)
                        scaleNum = Float(initialScaleData.text!)
                        
                        if offsetNum == 0 && scaleNum == 0 {
                            
                            y2 = Float(responseProcessedString!)
                            
                        }
                        
                        else if offsetNum != 0 && scaleNum == 0 {
                            
                            y2 = (inputValue2Num!-offsetNum!)/1
                            print(y2)
                            inputValue2.text = y2.cleanValue
                            
                        }
                        
                        else {
                        y2 = (inputValue2Num!-offsetNum!)/scaleNum!
                        print(y2)
                        inputValue2.text = y2.cleanValue
                        
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.present(alertFailQuery, animated: true)
                }
            case .failure(let error):
                print(error)
                self.present(alertFailConnect, animated: true)
            }
            client.close()
        }
        
    }
    
    func inhibitAlarms() {
        ip1String = self.ip1.text!
        ip1Num = Int(ip1String)
        ip2String = self.ip2.text!
        let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
        ip2Num = Int(ip2String[indexStartOfText...])
        ip3String = self.ip3.text!
        ip3Num = Int(ip3String[indexStartOfText...])
        ip4String = self.ip4.text!
        ip4Num = Int(ip4String[indexStartOfText...])
        portString = self.port.text!
        portNum = Int32(portString[indexStartOfText...])
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
            case .success:
                switch client.send(string: "!I\(point!)\r" ) {
                    case .success:
                        usleep(timeout)
                        alarmConnect = true
        case .failure(let error):
        print(error)
        self.present(alertFailQuery, animated: true)
        }
        
        case .failure(let error):
        print(error)
        self.present(alertFailConnect, animated: true)
            }
            client.close()
        }
        
    
       @objc func beginCalibration(sender: UIButton) {
        
        generator.impactOccurred()
        
        
        if calibrationState == true {
        
            if state == true {
                
                uninhibitAlarms()
                
            }
            
            calibrationState = false
            calibrationButton.setTitle("Calibrate", for: .normal)
            calibrationValue1Entry.isUserInteractionEnabled = false
            calibrationValue1Entry.backgroundColor = .gray
            calibrationValue2Entry.isUserInteractionEnabled = false
            calibrationValue2Entry.backgroundColor = .gray
            
        }
        
        else {
            if state == true {
                
                inhibitAlarms()
                
            }
            
            if alarmConnect == true {
            calibrationState = true
            calibrationButton.setTitle("Stop", for: .normal)
            calibrationValue1Entry.isUserInteractionEnabled = true
            calibrationValue1Entry.backgroundColor = .white
            calibrationValue2Entry.isUserInteractionEnabled = true
            calibrationValue2Entry.backgroundColor = .white
            }
            
            else if alarmConnect == false && state == false {
                
                calibrationState = true
                calibrationButton.setTitle("Stop", for: .normal)
                calibrationValue1Entry.isUserInteractionEnabled = true
                calibrationValue1Entry.backgroundColor = .white
                calibrationValue2Entry.isUserInteractionEnabled = true
                calibrationValue2Entry.backgroundColor = .white
                
            }
            
            else {
                print("no")
            }
            
            
        }
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        
        if switchState.isOn {
            state = true
            print(state!)
        } else {
            state = false
            print(state!)
        }
    }
    
    func uninhibitAlarms() {
        ip1String = self.ip1.text!
        ip1Num = Int(ip1String)
        ip2String = self.ip2.text!
        let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
        ip2Num = Int(ip2String[indexStartOfText...])
        ip3String = self.ip3.text!
        ip3Num = Int(ip3String[indexStartOfText...])
        ip4String = self.ip4.text!
        ip4Num = Int(ip4String[indexStartOfText...])
        portString = self.port.text!
        portNum = Int32(portString[indexStartOfText...])
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
    switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "!U\(point!)\r" ) {
                case .success:
                    alarmConnect = false
                    return
                case .failure(let error):
                    print(error)
                    self.present(alertFailQuery, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFailConnect, animated: true)
    }
        client.close()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"+-.0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        descriptionData.text = descriptorText
        tagData.text = tagText
        calibrationPointData.text = pointNumber
        offsetData.text = offsetText
        initialScaleData.text = scaleText
        point = pointNumber
        calibrationValue1Entry.text = ""
        calibrationValue2Entry.text = ""
        inputValue1.text = ""
        inputValue2.text = ""
        customerText.text = customerName
        siteText.text = siteName
        systemText.text = systemName
        
        
        
    }
    
    @objc func calculate(sender: UIButton) {
        
        if inputValue1.text == "" && inputValue2.text == "" {
            
            
        }
        
        else {
            
        generator.impactOccurred()
        let inputValue1NumX = Float(calibrationValue1Entry.text!)
        let inputValue2NumX = Float(calibrationValue2Entry.text!)
        let newScale = (inputValue2NumX!-inputValue1NumX!)/(y2-y1)
        let newOffset = (inputValue1NumX!)-(newScale*y1)
        finalScaleData.text = "\(newScale)"
        finalOffsetData.text = "\(newOffset)"
        print(newScale)
        print(newOffset)
            ip1String = self.ip1.text!
            ip1Num = Int(ip1String)
            ip2String = self.ip2.text!
            let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
            ip2Num = Int(ip2String[indexStartOfText...])
            ip3String = self.ip3.text!
            ip3Num = Int(ip3String[indexStartOfText...])
            ip4String = self.ip4.text!
            ip4Num = Int(ip4String[indexStartOfText...])
            portString = self.port.text!
            portNum = Int32(portString[indexStartOfText...])
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "!S\(point!),\(newScale)\r" ) {
            case .success:
                usleep(timeout)
            case .failure(let error):
                print(error)
                self.present(alertFailQuery, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFailConnect, animated: true)
        }
        client.close()
            ip1String = self.ip1.text!
            ip1Num = Int(ip1String)
            ip2String = self.ip2.text!
            ip2Num = Int(ip2String[indexStartOfText...])
            ip3String = self.ip3.text!
            ip3Num = Int(ip3String[indexStartOfText...])
            ip4String = self.ip4.text!
            ip4Num = Int(ip4String[indexStartOfText...])
            portString = self.port.text!
            portNum = Int32(portString[indexStartOfText...])
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "!O\(point!),\(newOffset)\r" ) {
            case .success:
                usleep(timeout)
            case .failure(let error):
                print(error)
                self.present(alertFailQuery, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFailConnect, animated: true)
        }
            client.close()
        }
    }
    
}

