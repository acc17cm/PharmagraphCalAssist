//
//  ViewController.swift
//  PharamgraphApp
//
//  Created by Cameron McWilliam on 18/07/2018.
//  Copyright © 2018 Cameron McWilliam. All rights reserved.
//
import Foundation
import UIKit
import SwiftSocket
import SQLite

class ViewController: UIViewController, UITextFieldDelegate {
   
   //Declaring all the elements of the app
   var presetTitle : UILabel!
   var ipString : UILabel!
   var portString: UILabel!
   var ip1 : UITextField!
   var ip2 : UITextField!
   var ip3 : UITextField!
   var ip4 : UITextField!
   var port : UITextField!
   var point : UITextField!
   var interval: UITextField!
   var executeButton: UIButton!
   var value1String: UILabel!
   var value2String: UILabel!
   var value3String: UILabel!
   var value4String: UILabel!
   var value5String: UILabel!
   var value6String: UILabel!
   var value7String: UILabel!
   var value8String: UILabel!
   var value1: UITextField!
   var value2: UITextField!
   var value3: UITextField!
   var value4: UITextField!
   var value5: UITextField!
   var value6: UITextField!
   var value7: UITextField!
   var value8: UITextField!
   var isRunning = false
   var empty: UITextField!
   var timer: Timer?
   var defaults = UserDefaults.standard
   var alertFail: UIAlertController!
   var generator: UIImpactFeedbackGenerator!
   
   override func viewDidLoad() {
      
      super.viewDidLoad()
      
      generator = UIImpactFeedbackGenerator(style: .heavy)
      
      //Background Colour white
      view.backgroundColor = UIColor.white
      
      //Placeholder for attributes is empty string
      let placeholder = NSAttributedString(string: "")
      
      //Defaults for persistence
      let defaults = UserDefaults.standard
      
      //Title of preset at the top of the stage
      presetTitle = UILabel()
      presetTitle.text = defaults.value(forKey: "name") as? String
      presetTitle.sizeToFit()
      presetTitle.adjustsFontSizeToFitWidth = true;
      presetTitle.textAlignment = .center
      presetTitle.minimumScaleFactor = 12.0
      presetTitle.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2-180);
      view.addSubview(presetTitle)
      
      //Displays "I.P. Address:" above where user enters IP in
      ipString = UILabel()
      ipString.text = "I.P. Address:"
      ipString.sizeToFit()
      ipString.adjustsFontSizeToFitWidth = true;
      ipString.center = CGPoint(x: 88, y: 85);
      
      //Displays "Port:" above where user enters port in
      portString = UILabel()
      portString.text = "Port:"
      portString.sizeToFit()
      portString.adjustsFontSizeToFitWidth = true;
      portString.center = CGPoint(x: 350, y: 85);
      
      //First textfield where user enters IP
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
      
      point = UITextField(frame: CGRect(x: view.bounds.width/2-13, y: view.bounds.height/2-20, width: 70, height: 20))
      point.keyboardType = UIKeyboardType.numberPad
      point.attributedPlaceholder = placeholder
      point.textColor = UIColor.black
      point.delegate = self
      point.borderStyle = UITextField.BorderStyle.roundedRect
      point.clearsOnBeginEditing = false
      point.text = defaults.value(forKey: "pointText") as? String
      if point.text == nil {
         defaults.set("\u{200B}", forKey: "pointText")
         point.text = defaults.value(forKey: "pointText") as? String
      }
      else {
      }
      
      //Textfield where user enters the interval in
      interval = UITextField(frame: CGRect(x: 310, y: 200, width: 80, height: 20))
      interval.keyboardType = UIKeyboardType.numberPad
      interval.attributedPlaceholder = placeholder
      interval.textColor = UIColor.black
      interval.delegate = self
      interval.borderStyle = UITextField.BorderStyle.roundedRect
      interval.clearsOnBeginEditing = false
      interval.text = defaults.value(forKey: "intervalText") as? String
      if interval.text == nil {
         defaults.set("\u{200B}", forKey: "intervalText")
         interval.text = defaults.value(forKey: "intervalText") as? String
      }
      else {
      }
      
      //Displays value 1 in non editable text-field
      value1String = UILabel()
      value1String.text = "Value 1:"
      value1String.sizeToFit()
      value1String.adjustsFontSizeToFitWidth = true;
      value1String.center = CGPoint(x: 71, y: 230);
      view.addSubview(value1String)
      
      value1 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 220, width: 100, height: 20))
      value1.attributedPlaceholder = placeholder
      value1.textColor = UIColor.black
      value1.delegate = self
      value1.borderStyle = UITextField.BorderStyle.roundedRect
      value1.isUserInteractionEnabled = false
      view.addSubview(value1)
      
      //Displays value 2 in non editable text-field
      value2String = UILabel()
      value2String.text = "Value 2:"
      value2String.sizeToFit()
      value2String.adjustsFontSizeToFitWidth = true;
      value2String.center = CGPoint(x: 71, y: 270);
      view.addSubview(value2String)
      
      value2 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 260, width: 100, height: 20))
      value2.attributedPlaceholder = placeholder
      value2.textColor = UIColor.black
      value2.delegate = self
      value2.borderStyle = UITextField.BorderStyle.roundedRect
      value2.isUserInteractionEnabled = false
      view.addSubview(value2)
      
      //Displays value 3 in non editable text-field
      value3String = UILabel()
      value3String.text = "Value 3:"
      value3String.sizeToFit()
      value3String.adjustsFontSizeToFitWidth = true;
      value3String.center = CGPoint(x: 71, y: 310);
      view.addSubview(value3String)
      
      value3 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 300, width: 100, height: 20))
      value3.attributedPlaceholder = placeholder
      value3.textColor = UIColor.black
      value3.delegate = self
      value3.borderStyle = UITextField.BorderStyle.roundedRect
      value3.isUserInteractionEnabled = false
      view.addSubview(value3)
      
      //Displays value 4 in non editable text-field
      value4String = UILabel()
      value4String.text = "Value 4:"
      value4String.sizeToFit()
      value4String.adjustsFontSizeToFitWidth = true;
      value4String.center = CGPoint(x: 71, y: 350);
      view.addSubview(value4String)
      
      value4 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 340, width: 100, height: 20))
      value4.attributedPlaceholder = placeholder
      value4.textColor = UIColor.black
      value4.delegate = self
      value4.borderStyle = UITextField.BorderStyle.roundedRect
      value4.isUserInteractionEnabled = false
      view.addSubview(value4)
      
      //Displays value 5 in non editable text-field
      value5String = UILabel()
      value5String.text = "Value 5:"
      value5String.sizeToFit()
      value5String.adjustsFontSizeToFitWidth = true;
      value5String.center = CGPoint(x: 71, y: 390);
      view.addSubview(value5String)
      
      value5 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 380, width: 100, height: 20))
      value5.attributedPlaceholder = placeholder
      value5.textColor = UIColor.black
      value5.delegate = self
      value5.borderStyle = UITextField.BorderStyle.roundedRect
      value5.isUserInteractionEnabled = false
      view.addSubview(value5)
      
      //Displays value 6 in non editable text-field
      value6String = UILabel()
      value6String.text = "Value 6:"
      value6String.sizeToFit()
      value6String.adjustsFontSizeToFitWidth = true;
      value6String.center = CGPoint(x: 71, y: 430);
      view.addSubview(value6String)
      
      value6 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 420, width: 100, height: 20))
      value6.attributedPlaceholder = placeholder
      value6.textColor = UIColor.black
      value6.delegate = self
      value6.borderStyle = UITextField.BorderStyle.roundedRect
      value6.isUserInteractionEnabled = false
      view.addSubview(value6)
      
      //Displays value 7 in non editable text-field
      value7String = UILabel()
      value7String.text = "Value 7:"
      value7String.sizeToFit()
      value7String.adjustsFontSizeToFitWidth = true;
      value7String.center = CGPoint(x: 71, y: 470);
      view.addSubview(value7String)
      
      value7 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 460, width: 100, height: 20))
      value7.attributedPlaceholder = placeholder
      value7.textColor = UIColor.black
      value7.delegate = self
      value7.borderStyle = UITextField.BorderStyle.roundedRect
      value7.isUserInteractionEnabled = false
      view.addSubview(value7)
      
      //Displays value 7 in non editable text-field
      value8String = UILabel()
      value8String.text = "Value 8:"
      value8String.sizeToFit()
      value8String.adjustsFontSizeToFitWidth = true;
      value8String.center = CGPoint(x: 71, y: 510);
      view.addSubview(value8String)
      
      value8 = UITextField(frame: CGRect(x: view.bounds.width/2-47, y: 500, width: 100, height: 20))
      value8.attributedPlaceholder = placeholder
      value8.textColor = UIColor.black
      value8.delegate = self
      value8.borderStyle = UITextField.BorderStyle.roundedRect
      value8.isUserInteractionEnabled = false
      view.addSubview(value8)
      
      //Button where user starts and stops the program
      executeButton = UIButton(frame: CGRect(x: view.bounds.width/2-35, y: view.bounds.height/2+210, width: 80, height: 30))
      executeButton.backgroundColor = .clear
      executeButton.showsTouchWhenHighlighted = true
      executeButton.layer.cornerRadius = 5
      executeButton.layer.borderWidth = 1
      executeButton.layer.borderWidth = 1
      executeButton.layer.borderColor = UIColor.gray.cgColor
      executeButton.setTitleColor(UIColor.darkGray, for: .normal)
      executeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
      executeButton.setTitle("Start", for: .normal)
      self.view.addSubview(executeButton)
      
      alertFail = UIAlertController(title: "Connection Failed", message: "Please check your connection and try again", preferredStyle: .alert)
      alertFail.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      
   }
   
   func startTimer()
   {
      if timer == nil {
         
         generator.impactOccurred()
         let intervalString = self.interval.text!
         let indexStartOfText = intervalString.index(intervalString.startIndex, offsetBy: 1)
         let intervalNum = Int(intervalString[indexStartOfText...])
         timer = Timer.scheduledTimer(timeInterval: Double(intervalNum!),
                                      target: self,
                                      selector: #selector(ViewController.connectTo),
                                      userInfo: nil,
                                      repeats: true)
         timer!.fire()
      }
   }
   
   func stopTimer()
   {
      if timer != nil {
         generator.impactOccurred()
         timer!.invalidate()
         timer = nil
      }
   }
   
   //Changes appearance of button when user interacts with it
   @objc func buttonAction(_ sender: UIButton) {
      
      defaults.set(self.ip1.text, forKey: "ip1Text")
      defaults.set(self.ip2.text, forKey: "ip2Text")
      defaults.set(self.ip3.text, forKey: "ip3Text")
      defaults.set(self.ip4.text, forKey: "ip4Text")
      defaults.set(self.port.text, forKey: "portText")
      defaults.set(self.interval.text, forKey: "intervalText")
      
      var i = 0
      
      if ip1.text != "" {
         i += 1
      }
      
      if ip2.text != "\u{200B}" {
         i += 1
      }
      
      if ip3.text != "\u{200B}" {
         i += 1
      }
      
      if ip4.text != "\u{200B}" {
         i += 1
      }
      
      if port.text != "\u{200B}" {
         i += 1
      }
      
      if interval.text != "\u{200B}" {
         i += 1
      }
      
      
      if i != 6 {
         
         let alert = UIAlertController(title: "Invalid input", message: "Please enter all fields", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
         self.present(alert, animated: true)
         
      }
         
      else {
         
         if isRunning == false {
            
            executeButton.setTitle("Stop", for: .normal)
            isRunning = true
            ip1.backgroundColor = .gray
            ip2.backgroundColor = .gray
            ip3.backgroundColor = .gray
            ip4.backgroundColor = .gray
            port.backgroundColor = .gray
            interval.backgroundColor = .gray
            ip1.textColor = .lightGray
            ip2.textColor = .lightGray
            ip3.textColor = .lightGray
            ip4.textColor = .lightGray
            port.textColor = .lightGray
            interval.textColor = .lightGray
            ip1.isUserInteractionEnabled = false
            ip2.isUserInteractionEnabled = false
            ip3.isUserInteractionEnabled = false
            ip4.isUserInteractionEnabled = false
            port.isUserInteractionEnabled = false
            interval.isUserInteractionEnabled = false
            
            startTimer()
            
         }
            
         else {
            
            stopTimer()
            executeButton.setTitle("Start", for: .normal)
            isRunning = false
            ip1.backgroundColor = .white
            ip2.backgroundColor = .white
            ip3.backgroundColor = .white
            ip4.backgroundColor = .white
            port.backgroundColor = .white
            interval.backgroundColor = .white
            ip1.textColor = .black
            ip2.textColor = .black
            ip3.textColor = .black
            ip4.textColor = .black
            port.textColor = .black
            interval.textColor = .black
            ip1.isUserInteractionEnabled = true
            ip2.isUserInteractionEnabled = true
            ip3.isUserInteractionEnabled = true
            ip4.isUserInteractionEnabled = true
            port.isUserInteractionEnabled = true
            interval.isUserInteractionEnabled = true
            
         }
      }
   }
   
   @objc func connectTo() {
      
      executeButton.setTitle("Stop", for: .normal)
      let ip1String = self.ip1.text!
      let ip1Num = Int(ip1String)
      let ip2String = self.ip2.text!
      let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
      let ip2Num = Int(ip2String[indexStartOfText...])
      let ip3String = self.ip3.text!
      let ip3Num = Int(ip3String[indexStartOfText...])
      let ip4String = self.ip4.text!
      let ip4Num = Int(ip4String[indexStartOfText...])
      let portString = self.port.text!
      let portNum = Int32(portString[indexStartOfText...])
      
      print("\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!) Port: \(portNum!)")
      
      let client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
      switch client.connect(timeout: 11) {
      case .success:
         switch client.send(string: "#0083\r" ) {
         case .success:
            sleep(10)
            guard let data = client.read(1024*10)
               else {
                  client.close()
                  return
            }
            
            
            let response = String(bytes: data, encoding: .utf8)
            
            var checkSumCalculated = 0
            
            for i in data.prefix(57) {
               
               let valueString = String(i)
               let value = Int(valueString)
               checkSumCalculated += value!
               
            }
            
            
            var checkSumCalculatedString = String(format:"%02X", checkSumCalculated)
            checkSumCalculatedString = String(checkSumCalculatedString[indexStartOfText...])
            
            let checkSumStartOfText = response!.index(response!.startIndex, offsetBy: 57)
            let checkSumEndOfText = response!.index(response!.endIndex, offsetBy: -2)
            let checkSumReceived = response![checkSumStartOfText...checkSumEndOfText]
            
            print (checkSumCalculatedString)
            print (checkSumReceived)
            
            if checkSumReceived == checkSumCalculatedString && response!.count == 60 {
               print ("Connected")
               print (response!)
               
               let value1StartOfText = response!.index((response?.startIndex)!, offsetBy: 1)
               let value1EndOfText = response!.index((response?.endIndex)!, offsetBy: -53)
               let value1Text = response![value1StartOfText...value1EndOfText]
               let value1String = String(value1Text)
               value1.text = value1String
               
               let value2StartOfText = response!.index((response?.startIndex)!, offsetBy: 8)
               let value2EndOfText = response!.index((response?.endIndex)!, offsetBy: -46)
               let value2Text = response![value2StartOfText...value2EndOfText]
               let value2String = String(value2Text)
               value2.text = value2String
               
               let value3StartOfText = response!.index((response?.startIndex)!, offsetBy: 15)
               let value3EndOfText = response!.index((response?.endIndex)!, offsetBy: -39)
               let value3Text = response![value3StartOfText...value3EndOfText]
               let value3String = String(value3Text)
               value3.text = value3String
               
               let value4StartOfText = response!.index((response?.startIndex)!, offsetBy: 22)
               let value4EndOfText = response!.index((response?.endIndex)!, offsetBy: -32)
               let value4Text = response![value4StartOfText...value4EndOfText]
               let value4String = String(value4Text)
               value4.text = value4String
               
               let value5StartOfText = response!.index((response?.startIndex)!, offsetBy: 29)
               let value5EndOfText = response!.index((response?.endIndex)!, offsetBy: -25)
               let value5Text = response![value5StartOfText...value5EndOfText]
               let value5String = String(value5Text)
               value5.text = value5String
               
               let value6StartOfText = response!.index((response?.startIndex)!, offsetBy: 36)
               let value6EndOfText = response!.index((response?.endIndex)!, offsetBy: -18)
               let value6Text = response![value6StartOfText...value6EndOfText]
               let value6String = String(value6Text)
               value6.text = value6String
               
               let value7StartOfText = response!.index((response?.startIndex)!, offsetBy: 43)
               let value7EndOfText = response!.index((response?.endIndex)!, offsetBy: -11)
               let value7Text = response![value7StartOfText...value7EndOfText]
               let value7String = String(value7Text)
               value7.text = value7String
               
               let value8StartOfText = response!.index((response?.startIndex)!, offsetBy: 50)
               let value8EndOfText = response!.index((response?.endIndex)!, offsetBy: -4)
               let value8Text = response![value8StartOfText...value8EndOfText]
               let value8String = String(value8Text)
               value8.text = value8String
               
            }
               
            else {
               print ("Connection Failure")
               self.present(alertFail, animated: true)
               
            }
            
         case .failure(let error):
            print(error)
            print ("Connection Failure")
            self.present(alertFail, animated: true)
            
            stopTimer()
            isRunning = false
            ip1.backgroundColor = .white
            ip2.backgroundColor = .white
            ip3.backgroundColor = .white
            ip4.backgroundColor = .white
            port.backgroundColor = .white
            interval.backgroundColor = .white
            ip1.textColor = .black
            ip2.textColor = .black
            ip3.textColor = .black
            ip4.textColor = .black
            port.textColor = .black
            interval.textColor = .black
            ip1.isUserInteractionEnabled = true
            ip2.isUserInteractionEnabled = true
            ip3.isUserInteractionEnabled = true
            ip4.isUserInteractionEnabled = true
            port.isUserInteractionEnabled = true
            interval.isUserInteractionEnabled = true
            executeButton.setTitle("Start", for: .normal)
            
         }
         
      case .failure(let error):
         print(error)
         print ("Connection Failure")
         self.present(alertFail, animated: true)
         
         stopTimer()
         isRunning = false
         ip1.backgroundColor = .white
         ip2.backgroundColor = .white
         ip3.backgroundColor = .white
         ip4.backgroundColor = .white
         port.backgroundColor = .white
         interval.backgroundColor = .white
         ip1.textColor = .black
         ip2.textColor = .black
         ip3.textColor = .black
         ip4.textColor = .black
         port.textColor = .black
         interval.textColor = .black
         ip1.isUserInteractionEnabled = true
         ip2.isUserInteractionEnabled = true
         ip3.isUserInteractionEnabled = true
         ip4.isUserInteractionEnabled = true
         port.isUserInteractionEnabled = true
         interval.isUserInteractionEnabled = true
         executeButton.setTitle("Start", for: .normal)
         
      }
      
      client.close()
       
   }
   
   
   //Main functions of textfield
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      let char = string.cString(using: String.Encoding.utf8)!
      let isBackSpace = strcmp(char, "\\b")
      
      let alert = UIAlertController(title: "Invalid IP Input", message: "Please enter a valid IP (0-255)", preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      
      let alertPort = UIAlertController(title: "Invalid Port Input", message: "Please enter a valid Port (0-65535)", preferredStyle: .alert)
      
      alertPort.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      
      let alertInterval = UIAlertController(title: "Invalid Interval Input", message: "Please enter a valid Interval (0-3600)", preferredStyle: .alert)
      
      alertInterval.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
      
      let currentCharacterCount = ((textField.text?.count)! + string.count) - 1
      
      switch (textField, currentCharacterCount) {
      case (self.ip1, 3):
         let ip1Num = Int(self.ip1.text!)
         if 0...255 ~= ip1Num! {
            self.ip2.becomeFirstResponder()
         }
         else {
            self.present(alert, animated: true)
         }
      case (self.ip2, 4):
         let ip2String = self.ip2.text!
         let indexStartOfText = ip2String.index(ip2String.startIndex, offsetBy: 1)
         let ip2Num = Int(ip2String[indexStartOfText...])
         if 0...255 ~= ip2Num! {
            self.ip3.becomeFirstResponder()
         }
         else {
            self.present(alert, animated: true)
         }
      case (self.ip3, 4):
         let ip3String = self.ip3.text!
         let indexStartOfText = ip3String.index(ip3String.startIndex, offsetBy: 1)
         let ip3Num = Int(ip3String[indexStartOfText...])
         if 0...255 ~= ip3Num! {
            self.ip4.becomeFirstResponder()
         }
         else {
            self.present(alert, animated: true)
         }
      case (self.ip4, 4):
         let ip4String = self.ip4.text!
         let indexStartOfText = ip4String.index(ip4String.startIndex, offsetBy: 1)
         let ip4Num = Int(ip4String[indexStartOfText...])
         if 0...255 ~= ip4Num! {
            self.port.becomeFirstResponder()
         }
         else {
            self.present(alert, animated: true)
         }
      case (self.port, 6):
         let portString = self.port.text!
         let indexStartOfText = portString.index(portString.startIndex, offsetBy: 1)
         let portNum = Int(portString[indexStartOfText...])
         if 0...65535 ~= portNum! {
            self.interval.becomeFirstResponder()
         }
         else {
            self.present(alertPort, animated: true)
         }
      case (self.interval, 5):
         let intervalString = self.interval.text!
         let indexStartOfText = intervalString.index(intervalString.startIndex, offsetBy: 1)
         let intervalNum = Int(intervalString[indexStartOfText...])
         if 0...3600 ~= intervalNum! {
            self.interval.endEditing(true)
         }
         else {
            self.present(alertInterval, animated: true)
         }
      case (self.ip2, 0):
         if isBackSpace == -92 && ip2.text == "\u{200B}" {
            ip1.becomeFirstResponder()
         }
         else {
            
            
         }
      case (self.ip3, 0):
         if isBackSpace == -92 && ip3.text == "\u{200B}" {
            ip2.becomeFirstResponder()
            
         }
         else {
            
            
         }
      case (self.ip4, 0):
         if isBackSpace == -92 && ip4.text == "\u{200B}" {
            ip3.becomeFirstResponder()
            
         }
         else {
            
            
         }
      case (self.port, 0):
         if isBackSpace == -92 && port.text == "\u{200B}" {
            ip4.becomeFirstResponder()
            
         }
         else {
            
         }
      case (self.interval, 0):
         if isBackSpace == -92 && interval.text == "\u{200B}" {
            port.becomeFirstResponder()
            
         }
         else {
            
            
         }
      default:
         break
      }
      
      return true
   }
   
   override func viewWillAppear(_ animated: Bool) {
   
   presetTitle.text = ""
   ip1.text = defaults.value(forKey: "ip1Text") as? String
   ip2.text = defaults.value(forKey: "ip2Text") as? String
   ip3.text = defaults.value(forKey: "ip3Text") as? String
   ip4.text = defaults.value(forKey: "ip4Text") as? String
   port.text = defaults.value(forKey: "portText") as? String
   interval.text = defaults.value(forKey: "intervalText") as? String
   
   
   //Have to redo the preset title to keep centred
   presetTitle = UILabel()
   presetTitle.text = defaults.value(forKey: "name") as? String
   presetTitle.sizeToFit()
   presetTitle.adjustsFontSizeToFitWidth = true;
   presetTitle.textAlignment = .center
   presetTitle.minimumScaleFactor = 12.0
   presetTitle.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2-180);
   view.addSubview(presetTitle)
      
   }
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

}



