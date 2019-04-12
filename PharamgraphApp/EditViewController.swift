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

class EditViewController: UIViewController, UITextFieldDelegate {
    
    //Declaring all the elements of the app
    var ipString : UILabel!
    var portString: UILabel!
    var pointString: UILabel!
    var presetTitle: UILabel!
    var ip1 : UITextField!
    var ip2 : UITextField!
    var ip3 : UITextField!
    var ip4 : UITextField!
    var dot1 : UILabel!
    var dot2 : UILabel!
    var dot3 : UILabel!
    var port : UITextField!
    var point : UITextField!
    var cameraButton : UIButton!
    var intervalString: UILabel!
    var interval: UITextField!
    var clearButton: UIButton!
    var isRunning = false
    var empty: UITextField!
    var timer: Timer?
    var defaults = UserDefaults.standard
    var savePreset: UIButton!
    var dbP: OpaquePointer?
    var stmt: OpaquePointer?
    var presetList = [Preset]()
    var generator: UIImpactFeedbackGenerator!
    
    override func viewDidLoad() {
        
    
        generator = UIImpactFeedbackGenerator(style: .heavy) // Initialisers for haptic generator
        // Keyboard notifications for moving view up when textfield is being entered
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        super.viewDidLoad()
        
        //Background Colour white
        view.backgroundColor = UIColor.white
        
        //Placeholder for attributes is empty string
        let placeholder = NSAttributedString(string: "")
        
        //Defaults for persistence
        let defaults = UserDefaults.standard
        
        presetTitle = UILabel()
        presetTitle.text = defaults.value(forKey: "name") as? String
        presetTitle.sizeToFit()
        presetTitle.adjustsFontSizeToFitWidth = true;
        presetTitle.textAlignment = .center
        presetTitle.minimumScaleFactor = 12.0
        presetTitle.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2-250);
        view.addSubview(presetTitle)
        
        //Displays "I.P. Address:" above where user enters IP in
        ipString = UILabel()
        ipString.text = "IP Address:"
        ipString.sizeToFit()
        ipString.adjustsFontSizeToFitWidth = true;
        ipString.center = CGPoint(x: view.bounds.width/2-100, y: view.bounds.height/2-140);
        view.addSubview(ipString)
        
        //Displays "Port:" above where user enters port in
        pointString = UILabel()
        pointString.text = "Point:"
        pointString.sizeToFit()
        pointString.adjustsFontSizeToFitWidth = true;
        pointString.center = CGPoint(x: view.bounds.width/2+10, y: view.bounds.height/2-40);
        //view.addSubview(pointString)
        
        //Displays "Port:" above where user enters port in
        portString = UILabel()
        portString.text = "Port:"
        portString.sizeToFit()
        portString.adjustsFontSizeToFitWidth = true;
        portString.center = CGPoint(x: view.bounds.width/2-130, y: view.bounds.height/2-40);
        view.addSubview(portString)
        
        //First dot
        dot1 = UILabel()
        dot1.text = "."
        dot1.sizeToFit()
        dot1.adjustsFontSizeToFitWidth = true;
        dot1.center = CGPoint(x: view.bounds.width/2-85, y:view.bounds.height/2-90)
        view.addSubview(dot1)
        
        //Second dot
        dot2 = UILabel()
        dot2.text = "."
        dot2.sizeToFit()
        dot2.adjustsFontSizeToFitWidth = true;
        dot2.center = CGPoint(x: view.bounds.width/2-12, y: view.bounds.height/2-90)
        view.addSubview(dot2)
        
        //Third dot
        dot3 = UILabel()
        dot3.text = "."
        dot3.sizeToFit()
        dot3.adjustsFontSizeToFitWidth = true;
        dot3.center = CGPoint(x: view.bounds.width/2+58, y:view.bounds.height/2-90)
        view.addSubview(dot3)
        
        //First textfield where user enters IP
        ip1 = UITextField(frame: CGRect(x: view.bounds.width/2-152, y: view.bounds.height/2-103, width: 60, height: 20))
        ip1.keyboardType = UIKeyboardType.numberPad
        ip1.attributedPlaceholder = placeholder
        ip1.textColor = UIColor.black
        ip1.delegate = self
        ip1.borderStyle = UITextField.BorderStyle.roundedRect
        ip1.clearsOnBeginEditing = false
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip1.addDoneButtonToKeyboard(myAction:  #selector(self.ip1.resignFirstResponder))
        view.addSubview(ip1)
        
        //Second textfield where user enters IP
        ip2 = UITextField(frame: CGRect(x: 110, y: view.bounds.height/2-103, width: 60, height: 20))
        ip2.keyboardType = UIKeyboardType.numberPad
        ip2.attributedPlaceholder = placeholder
        ip2.textColor = UIColor.black
        ip2.delegate = self
        ip2.borderStyle = UITextField.BorderStyle.roundedRect
        ip2.clearsOnBeginEditing = false
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip2.addDoneButtonToKeyboard(myAction:  #selector(self.ip2.resignFirstResponder))
        view.addSubview(ip2)
        
        //Third textfield where user enters IP
        ip3 = UITextField(frame: CGRect(x: 180, y: view.bounds.height/2-103, width: 60, height: 20))
        ip3.keyboardType = UIKeyboardType.numberPad
        ip3.attributedPlaceholder = placeholder
        ip3.textColor = UIColor.black
        ip3.delegate = self
        ip3.borderStyle = UITextField.BorderStyle.roundedRect
        ip3.clearsOnBeginEditing = false
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip3.addDoneButtonToKeyboard(myAction:  #selector(self.ip3.resignFirstResponder))
        view.addSubview(ip3)
        
        //Fourth textfield where user enters IP
        ip4 = UITextField(frame: CGRect(x: 250, y: view.bounds.height/2-103, width: 60, height: 20))
        ip4.keyboardType = UIKeyboardType.numberPad
        ip4.attributedPlaceholder = placeholder
        ip4.textColor = UIColor.black
        ip4.delegate = self
        ip4.borderStyle = UITextField.BorderStyle.roundedRect
        ip4.clearsOnBeginEditing = false
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        ip4.addDoneButtonToKeyboard(myAction:  #selector(self.ip4.resignFirstResponder))
        view.addSubview(ip4)
        
        //Textfield where user enters port
        port = UITextField(frame: CGRect(x: view.bounds.width/2-150, y: view.bounds.height/2-20, width: 70, height: 20))
        port.keyboardType = UIKeyboardType.numberPad
        port.attributedPlaceholder = placeholder
        port.textColor = UIColor.black
        port.delegate = self
        port.borderStyle = UITextField.BorderStyle.roundedRect
        port.clearsOnBeginEditing = false
        port.text = defaults.value(forKey: "portText") as? String
        port.addDoneButtonToKeyboard(myAction:  #selector(self.port.resignFirstResponder))
        view.addSubview(port)
        
        //Displays "Interval: " above where user enters interval in
        intervalString = UILabel()
        intervalString.text = "Interval:"
        intervalString.sizeToFit()
        intervalString.adjustsFontSizeToFitWidth = true;
        intervalString.center = CGPoint(x: view.bounds.width/2-120, y: view.bounds.height/2+45);
        view.addSubview(intervalString)
        
        //Textfield where user enters the interval in
        interval = UITextField(frame: CGRect(x: view.bounds.width/2-151, y: view.bounds.height/2+70, width: 80, height: 20))
        interval.keyboardType = UIKeyboardType.numberPad
        interval.attributedPlaceholder = placeholder
        interval.textColor = UIColor.black
        interval.delegate = self
        interval.borderStyle = UITextField.BorderStyle.roundedRect
        interval.clearsOnBeginEditing = false
        interval.text = defaults.value(forKey: "intervalText") as? String
        interval.addDoneButtonToKeyboard(myAction:  #selector(self.interval.resignFirstResponder))
        view.addSubview(interval)
        
        // Button that clears all fields
        clearButton = UIButton(frame: CGRect(x: view.bounds.width/2-90, y: view.bounds.height/2+200, width: 80, height: 30))
        clearButton.backgroundColor = .clear
        clearButton.showsTouchWhenHighlighted = true
        clearButton.layer.cornerRadius = 5
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderWidth = 1
        clearButton.layer.borderColor = UIColor.gray.cgColor
        clearButton.setTitleColor(UIColor.darkGray, for: .normal)
        clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
        clearButton.setTitle("Clear", for: .normal)
        self.view.addSubview(clearButton)
        
        // Button that saves all fields into a preset
        savePreset = UIButton(frame: CGRect(x: view.bounds.width/2+20, y: view.bounds.height/2+200, width: 80, height: 30))
        savePreset.backgroundColor = .clear
        savePreset.showsTouchWhenHighlighted = true
        savePreset.layer.cornerRadius = 5
        savePreset.layer.borderWidth = 1
        savePreset.layer.borderWidth = 1
        savePreset.layer.borderColor = UIColor.gray.cgColor
        savePreset.setTitleColor(UIColor.darkGray, for: .normal)
        savePreset.addTarget(self, action: #selector(presetAction), for: .touchUpInside)
        savePreset.setTitle("Save", for: .normal)
        self.view.addSubview(savePreset)
        
        // SQL commands to save to database
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("db.sqlite3")
        
        if sqlite3_open(fileURL.path, &dbP) != SQLITE_OK {
            print("error opening database")
        }
        
    }
    
    class Preset {
        
        var id: Int
        var name: String?
        var ip1: String?
        var ip2: String?
        var ip3: String?
        var ip4: String?
        var port: String?
        var point: String?
        var interval: String?
        
        init(id: Int, name: String?, ip1: String?, ip2: String?, ip3: String?, ip4: String?, port: String?, point: String?, interval: String?){
            
            self.id = id
            self.name = name
            self.ip1 = ip1
            self.ip2 = ip2
            self.ip3 = ip3
            self.ip4 = ip4
            self.port = port
            self.point = point
            self.interval = interval
            
        }
        
    }
    
    // Clears fields, puts invisible character into every field except first one
    @objc func clearAction(_sender: UIButton) {
        generator.impactOccurred()
        defaults.set("", forKey: "name")
        defaults.set("", forKey: "ip1Text")
        defaults.set("", forKey: "ip2Text")
        defaults.set("", forKey: "ip3Text")
        defaults.set("", forKey: "ip4Text")
        defaults.set("", forKey: "portText")
        defaults.set("", forKey: "pointText")
        defaults.set("", forKey: "intervalText")
        presetTitle.text =  defaults.value(forKey: "name") as? String
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        interval.text = defaults.value(forKey: "intervalText") as? String
    }
    
    // Save function that saves preset to database
    @objc func presetAction() {
        generator.impactOccurred()
        descriptorText = ""
        pointNumber = ""
        tagText = ""
        scaleText = ""
        offsetText = ""
        let alert = UIAlertController(title: "Preset name", message: "Enter preset name:", preferredStyle: .alert) // Banner appears
        
        // Text field in banner
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // Save button the banner
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let name = textField?.text
            self.presetTitle.text = name
            let ip1Data = self.ip1?.text
            let ip2Data = self.ip2?.text
            let ip3Data = self.ip3?.text
            let ip4Data = self.ip4?.text
            let portData = self.port?.text
            let intervalData = self.interval?.text
            self.defaults.set(self.presetTitle.text, forKey: "name")
            self.defaults.set(self.ip1.text, forKey: "ip1Text")
            self.defaults.set(self.ip2.text, forKey: "ip2Text")
            self.defaults.set(self.ip3.text, forKey: "ip3Text")
            self.defaults.set(self.ip4.text, forKey: "ip4Text")
            self.defaults.set(self.port.text, forKey: "portText")
            self.defaults.set(self.interval.text, forKey: "intervalText")
            
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try! Connection("\(path)/db.sqlite3")
            let presets = Table("presets")
            let idt = Expression<Int64>("id")
            let namet = Expression<String>("name")
            let ip1t = Expression<String>("ip1")
            let ip2t = Expression<String>("ip2")
            let ip3t = Expression<String>("ip3")
            let ip4t = Expression<String>("ip4")
            let portt = Expression<String>("port")
            let pointt = Expression<String>("point")
            let intervalt = Expression<String>("interval")
            
            try? db.run(presets.create { t in
                t.column(idt, primaryKey: true)
                t.column(namet, unique: true)
                t.column(ip1t)
                t.column(ip2t)
                t.column(ip3t)
                t.column(ip4t)
                t.column(portt)
                t.column(pointt)
                t.column(intervalt)
            })
            

            let insert = presets.insert(or: .replace, namet <- name!, ip1t <- ip1Data!, ip2t <- ip2Data!, ip3t <- ip3Data!, ip4t <- ip4Data!, portt <- portData!, pointt <- "1", intervalt <- intervalData!)
            let rowid = try! db.run(insert)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBar = appDelegate.tabBarController
            tabBar?.selectedIndex = 0
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Main functions of textfield, prevents invalid entries
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        let alert = UIAlertController(title: "Invalid IP Input", message: "Please enter a valid IP (0-255)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let alertPort = UIAlertController(title: "Invalid Port Input", message: "Please enter a valid Port (0-65535)", preferredStyle: .alert)
        
        alertPort.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let alertPoint = UIAlertController(title: "Invalid Point Input", message: "Please enter a valid Point Number (0-10000)", preferredStyle: .alert)
        
        alertPoint.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let alertInterval = UIAlertController(title: "Invalid Interval Input", message: "Please enter a valid Interval (0-3600)", preferredStyle: .alert)
        
        alertInterval.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        let currentCharacterCount = ((textField.text?.count)! + string.count) - 1
        
        // Automatically switch to next textfield, dependant on backspace or typing in
        
        switch (textField, currentCharacterCount) {
        case (self.ip1, 3):
            let ip1Num = Int(self.ip1.text!)
            if self.ip1.canBecomeFirstResponder == true {
            if 0...255 ~= ip1Num! {
                //self.ip2.becomeFirstResponder()
            }
            else {
                self.present(alert, animated: true)
            }
            }
        case (self.ip2, 3):
            let ip2Num = Int(self.ip2.text!)
            if 0...255 ~= ip2Num! {
                //self.ip3.becomeFirstResponder()
            }
            else {
                self.present(alert, animated: true)
            }
        case (self.ip3, 3):
            let ip3Num = Int(self.ip3.text!)
            if 0...255 ~= ip3Num! {
                //self.ip4.becomeFirstResponder()
            }
            else {
                self.present(alert, animated: true)
            }
        case (self.ip4, 3):
            let ip4Num = Int(self.ip4.text!)
            if 0...255 ~= ip4Num! {
                //self.port.becomeFirstResponder()
            }
            else {
                self.present(alert, animated: true)
            }
        case (self.port, 5):
            let portNum = Int(self.port.text!)
            if 0...65535 ~= portNum! {
                //self.interval.becomeFirstResponder()
            }
            else {
                self.present(alertPort, animated: true)
            }
            
        case (self.interval, 5):
            let intervalNum = Int(self.interval.text!)
            if 0...3600 ~= intervalNum! {
                self.interval.endEditing(true)
            }
            else {
                self.present(alertInterval, animated: true)
            }
            
        case (self.ip2, 0):
            if ip1.text!.count != 0 {
            let ip1Num = Int(self.ip1.text!)
            if 0...255 ~= ip1Num!  {
                
            }
            else {
                ip1.becomeFirstResponder()
                self.present(alert, animated: true)
                
            }
            }
        case (self.ip3, 0):
            if ip2.text!.count != 0 {
            let ip2Num = Int(self.ip2.text!)
            if 0...255 ~= ip2Num!  {
                
            }
            else {
                ip2.becomeFirstResponder()
                self.present(alert, animated: true)
                
            }
            }
        case (self.ip4, 0):
            if ip3.text!.count != 0 {
            let ip3Num = Int(self.ip3.text!)
            if 0...255 ~= ip3Num!  {
                
            }
            else {
                ip3.becomeFirstResponder()
                self.present(alert, animated: true)
                
            }
            }
        case (self.port, 0):
            if ip4.text!.count != 0 {
            let ip4Num = Int(self.ip4.text!)
            if 0...255 ~= ip4Num!  {
                
            }
            else {
                ip4.becomeFirstResponder()
                self.present(alert, animated: true)
                
            }
            }
        case (self.interval, 0):
            if port.text!.count != 0 {
            let portNum = Int(self.port.text!)
            if 0...65535 ~= portNum!  {
                
            }
            else {
                port.becomeFirstResponder()
                self.present(alertPort, animated: true)
                
            }
            }
            
        default:
            break
        }
        
        return true
 
    }
 
    // Saves values on view appearing
    
    override func viewWillAppear(_ animated: Bool) {
        
        presetTitle.text = ""
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        interval.text = defaults.value(forKey: "intervalText") as? String
        
        presetTitle = UILabel()
        presetTitle.text = defaults.value(forKey: "name") as? String
        presetTitle.sizeToFit()
        presetTitle.adjustsFontSizeToFitWidth = true;
        presetTitle.textAlignment = .center
        presetTitle.minimumScaleFactor = 12.0
        presetTitle.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2-250);
        view.addSubview(presetTitle)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}

// Adds function to UITextfield that adds a done button to keyboard
extension UITextField {
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}



