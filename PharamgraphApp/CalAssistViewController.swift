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
    var alertFail: UIAlertController!
    var alertCalculate: UIAlertController!
    var generator: UIImpactFeedbackGenerator!
    var alarmConnect: Bool!
    var timeout: UInt32!
    var customerText: UILabel!
    var siteText: UILabel!
    var systemText: UILabel!
    
    override func viewDidLoad() {
        
        state = false // Boolean value for if alarm switch is on, false = off, true = on
        alarmConnect = false // Boolean value for if alarms are inhibited
        point = pointNumber // Holds point number value
        calibrationState = false // Boolean value for if currently connected and calibrating
        timeout = 200000 // Timeout value
        generator = UIImpactFeedbackGenerator(style: .heavy) // Initialisers for haptic generator
        
        view.backgroundColor = UIColor.white
        
        // Keyboard notifications for moving view up when textfield is being entered
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let placeholder = NSAttributedString(string: "") //Sets placeholder as empty
        
        // Next ip and port fields are not visible on the view, they hold the values from the preset currently loaded
        
        ip1 = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2 = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3 = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4 = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port = UITextField(frame: CGRect(x: 40, y: 100, width: 60, height: 20))
        port.text = defaults.value(forKey: "portText") as? String
        
        // Grey rectangle that holds customer, site and system info
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 6, y: 100, width: 363, height: 120), cornerRadius: 20).cgPath
        layer.fillColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(layer)
        
        // Labels that hold values and customer, site and system
        
        customerText = UILabel()
        customerText.text = customerName
        customerText.sizeToFit()
        customerText.adjustsFontSizeToFitWidth = true;
        customerText.textAlignment = .left
        customerText.minimumScaleFactor = 10.0
        customerText.frame = CGRect(x: view.bounds.width/2-170, y: view.bounds.height/2-310, width: 300, height: 60)
        view.addSubview(customerText)
        
        siteText = UILabel()
        siteText.text = siteName
        siteText.sizeToFit()
        siteText.adjustsFontSizeToFitWidth = true;
        siteText.textAlignment = .left
        siteText.minimumScaleFactor = 10.0
        siteText.frame = CGRect(x: view.bounds.width/2-172, y: view.bounds.height/2-275, width: 300, height: 60)
        view.addSubview(siteText)
        
        systemText = UILabel()
        systemText.text = systemName
        systemText.sizeToFit()
        systemText.adjustsFontSizeToFitWidth = true;
        systemText.textAlignment = .left
        systemText.minimumScaleFactor = 10.0
        systemText.frame = CGRect(x: view.bounds.width/2-172, y: view.bounds.height/2-240, width: 300, height: 60)
        view.addSubview(systemText)
        
        // Creates rest of UI for CalAssist
        
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
        captureInput1.addTarget(self, action: #selector(captureAction1), for: .touchUpInside)
        self.view.addSubview(captureInput1)
        
        captureInput2 = UIButton(frame: CGRect(x: view.bounds.width/2-52, y: view.bounds.height/2+75, width: 75, height: 30))
        captureInput2.backgroundColor = .clear
        captureInput2.layer.cornerRadius = 5
        captureInput2.layer.borderWidth = 1
        captureInput2.layer.borderWidth = 1
        captureInput2.layer.borderColor = UIColor.gray.cgColor
        captureInput2.setTitleColor(UIColor.darkGray, for: .normal)
        captureInput2.setTitle("Capture", for: .normal)
        captureInput2.addTarget(self, action: #selector(captureAction2), for: .touchUpInside)
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
        
        // Banners that appear when errors occur
        
        alertFail = UIAlertController(title: "Connection Failed", message: "Please check your connection and try again", preferredStyle: .alert)
        alertFail.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        alertCalculate  = UIAlertController(title: "Calculation Error", message: "The two captured values must be unique", preferredStyle: .alert)
        alertCalculate.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
    }
    
    // Function that captures first value in calibration and puts it into the first text field
    
    @objc func captureAction1(sender: UIButton) {
        
        // Prevents user entering captuing if point number is empty or isnt editable yet
        if calibrationValue1Entry.isUserInteractionEnabled == false || pointNumber == nil {
            
        }
            
        else {
            
            generator.impactOccurred()
            
            print("Connecting")
            print(point!)
            
            // Connect to server
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
                        
                        // Gets data from server for calculation
                        
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
                            print(y1 as Any)
                            inputValue2.text = y1.cleanValue
                            
                        }
                            
                        else {
                            
                            y1 = (inputValue1Num!-offsetNum!)/scaleNum!
                            print(y1 as Any)
                            inputValue1.text = y1.cleanValue
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                    self.present(alertFail, animated: true)
                }
            case .failure(let error):
                print(error)
                print ("Connection failure connecting to ip")
                self.present(alertFail, animated: true)
            }
            client.close()
        }
        
    }
    
    // Same function as before, but puts value into second captured box
    
    @objc func captureAction2(sender: UIButton) {
        
        if calibrationValue2Entry.isUserInteractionEnabled == false || pointNumber == nil {
            
        }
            
        else {
            generator.impactOccurred()
            print("Connecting")
            print(point!)
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
                            print(y2 as Any)
                            inputValue2.text = y2.cleanValue
                            
                        }
                            
                        else {
                            
                            y2 = (inputValue2Num!-offsetNum!)/scaleNum!
                            print(y2 as Any)
                            inputValue2.text = y2.cleanValue
                            
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.present(alertFail, animated: true)
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
            client.close()
        }
        
    }
    
    // Function to inhibit alarms
    
    func inhibitAlarms() {
        
        if ip1Num == nil || ip2Num == nil || ip3Num == nil || ip4Num == nil || portNum == nil {
            
        }
        
        else {
            
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "!I\(point!)\r" ) {
            case .success:
                usleep(timeout)
                alarmConnect = true
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
            
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
        client.close()
        }
    }
    
    // Function to uninhibit alarms
    
    func uninhibitAlarms() {
        
        if ip1Num == nil || ip2Num == nil || ip3Num == nil || ip4Num == nil || portNum == nil {
            
        }
            
        else {
        
        client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "!U\(point!)\r" ) {
            case .success:
                alarmConnect = false
                return
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
        case .failure(let error):
            print(error)
            self.present(alertFail, animated: true)
        }
        
        client.close()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if calibrationState == true {
            
            calibrationState = false
            calibrationButton.setTitle("Calibrate", for: .normal)
            calibrationValue1Entry.isUserInteractionEnabled = false
            calibrationValue1Entry.backgroundColor = .gray
            calibrationValue1Entry.textColor = .white
            calibrationValue2Entry.isUserInteractionEnabled = false
            calibrationValue2Entry.backgroundColor = .gray
            calibrationValue2Entry.textColor = .white
        
        if state == true {
            
            alarmsSwitch.setOn(false, animated: true)
            state = false
            uninhibitAlarms()
            
        }
        }
    }
    // Calibration function, this function will inhibit or uninhibit alarms and changes how the button looks on the view
    
    @objc func beginCalibration(sender: UIButton) {
        
        generator.impactOccurred()
        
        if calibrationState == true  {
            
            if state == true {
                
                alarmsSwitch.setOn(false, animated: true)
                state = false
                uninhibitAlarms()
                
            }
            
            calibrationState = false
            calibrationButton.setTitle("Calibrate", for: .normal)
            calibrationValue1Entry.isUserInteractionEnabled = false
            calibrationValue1Entry.backgroundColor = .gray
            calibrationValue1Entry.textColor = .white
            calibrationValue2Entry.isUserInteractionEnabled = false
            calibrationValue2Entry.backgroundColor = .gray
            calibrationValue2Entry.textColor = .white
            
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
                calibrationValue1Entry.textColor = .black
                calibrationValue2Entry.isUserInteractionEnabled = true
                calibrationValue2Entry.backgroundColor = .white
                calibrationValue2Entry.textColor = .black
            }
                
            else if alarmConnect == false && state == false {
                
                calibrationState = true
                calibrationButton.setTitle("Stop", for: .normal)
                calibrationValue1Entry.isUserInteractionEnabled = true
                calibrationValue1Entry.backgroundColor = .white
                calibrationValue1Entry.textColor = .black
                calibrationValue2Entry.isUserInteractionEnabled = true
                calibrationValue2Entry.backgroundColor = .white
                calibrationValue2Entry.textColor = .black
                
            }
                
            else {
                print("no")
            }
            
        }
    }
    
    // Function that changes the switch boolean value
    
    @objc func stateChanged(switchState: UISwitch) {
        
        if switchState.isOn {
            state = true
            print(state!)
        } else {
            state = false
            print(state!)
        }
    }
    
    // Function that limits the input to the input values to a select few characters
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"+-.0123456789").inverted // Declares set
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "") // Filter out
        return string == numberFiltered
        
    }
    
    // Function gets called every time page loads
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ip1.text!.count != 0 {
            
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip1Num = Int(ip1.text!)
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip2Num = Int(ip2.text!)
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip3Num = Int(ip3.text!)
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        ip4Num = Int(ip4.text!)
        port.text = defaults.value(forKey: "portText") as? String
        portNum = Int32(port.text!)
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
        finalScaleData.text = ""
        finalOffsetData.text = ""
            
        }
        
    }
    
    // Function that moves view up when keyboard shows
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 170
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Main calculation for CalAssist function
    
    @objc func calculate(sender: UIButton) {
        
        if inputValue1.text == "" && inputValue2.text == "" {
            
        }
            
        else {
            
            generator.impactOccurred()
            
            // Caluclations that occur to get new scale and offset
            let inputValue1NumX = Float(calibrationValue1Entry.text!)
            let inputValue2NumX = Float(calibrationValue2Entry.text!)
            let newScale = (inputValue2NumX!-inputValue1NumX!)/(y2-y1)
            let newOffset = (inputValue1NumX!)-(newScale*y1)
            finalScaleData.text = "\(newScale)"
            finalOffsetData.text = "\(newOffset)"
            print(newScale)
            print(newOffset)
            
            if newScale.isNaN == false && newOffset.isNaN == false {
            // Sends new scale value to DBX
            client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
            switch client.connect(timeout: 1) {
            case .success:
                switch client.send(string: "!S\(point!),\(newScale)\r" ) {
                case .success:
                    usleep(timeout)
                case .failure(let error):
                    print(error)
                    self.present(alertFail, animated: true)
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
            client.close()
            
            // Sends new offset value to DBX
            client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
            switch client.connect(timeout: 1) {
            case .success:
                switch client.send(string: "!O\(point!),\(newOffset)\r") {
                case .success:
                    usleep(timeout)
                case .failure(let error):
                    print(error)
                    self.present(alertFail, animated: true)
                }
            case .failure(let error):
                print(error)
                self.present(alertFail, animated: true)
            }
            client.close()
          }
            else {
                self.present(alertCalculate, animated: true)
                finalOffsetData.text = ""
                finalScaleData.text = ""
            }
        }
    }
    
}
