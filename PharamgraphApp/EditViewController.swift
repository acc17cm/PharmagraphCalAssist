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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Background Colour white
        view.backgroundColor = UIColor.white
        
        //Placeholder for attributes is empty string
        let placeholder = NSAttributedString(string: "")
        
        //Defaults for persistence
        let defaults = UserDefaults.standard
        
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
        if ip2.text == nil {
            defaults.set("\u{200B}", forKey: "ip2Text")
            ip2.text = defaults.value(forKey: "ip2Text") as? String
        }
        else {
        }
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
        if ip3.text == nil {
            defaults.set("\u{200B}", forKey: "ip3Text")
            ip3.text = defaults.value(forKey: "ip3Text") as? String
        }
        else {
        }
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
        if ip4.text == nil {
            defaults.set("\u{200B}", forKey: "ip4Text")
            ip4.text = defaults.value(forKey: "ip4Text") as? String
        }
        else {
        }
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
        if port.text == nil {
            defaults.set("\u{200B}", forKey: "portText")
            port.text = defaults.value(forKey: "portText") as? String
        }
        else {
        }
        port.addDoneButtonToKeyboard(myAction:  #selector(self.port.resignFirstResponder))
        view.addSubview(port)
        
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
        point.addDoneButtonToKeyboard(myAction:  #selector(self.point.resignFirstResponder))
        //view.addSubview(point)
        
        cameraButton = UIButton(frame: CGRect(x: view.bounds.width/2+65, y: view.bounds.height/2-23, width: 110, height: 25))
        cameraButton.backgroundColor = .clear
        cameraButton.showsTouchWhenHighlighted = true
        cameraButton.layer.cornerRadius = 5
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = UIColor.gray.cgColor
        cameraButton.setTitleColor(UIColor.darkGray, for: .normal)
        cameraButton.addTarget(self, action: #selector(pushCamera), for: .touchUpInside)
        cameraButton.setTitle("QR Scanner", for: .normal)
        //self.view.addSubview(cameraButton)
        
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
        if interval.text == nil {
            defaults.set("\u{200B}", forKey: "intervalText")
            interval.text = defaults.value(forKey: "intervalText") as? String
        }
        else {
        }
        interval.addDoneButtonToKeyboard(myAction:  #selector(self.interval.resignFirstResponder))
        view.addSubview(interval)
        
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
    
    @objc func pushCamera(_sender: UIButton) {
      
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBar = appDelegate.tabBarController
        tabBar?.selectedIndex = 3
        
        
    }
    
    @objc func clearAction(_sender: UIButton) {
        defaults.set("", forKey: "ip1Text")
        defaults.set("\u{200B}", forKey: "ip2Text")
        defaults.set("\u{200B}", forKey: "ip3Text")
        defaults.set("\u{200B}", forKey: "ip4Text")
        defaults.set("\u{200B}", forKey: "portText")
        defaults.set("\u{200B}", forKey: "pointText")
        defaults.set("\u{200B}", forKey: "intervalText")
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        point.text = defaults.value(forKey: "pointText") as? String
        interval.text = defaults.value(forKey: "intervalText") as? String
    }
    
    func readValues(){
        
        //first empty the list of heroes
        presetList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM presets"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(dbP, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(dbP)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let ip1 = String(cString: sqlite3_column_text(stmt, 2))
            let ip2 = String(cString: sqlite3_column_text(stmt, 3))
            let ip3 = String(cString: sqlite3_column_text(stmt, 4))
            let ip4 = String(cString: sqlite3_column_text(stmt, 5))
            let port = String(cString: sqlite3_column_text(stmt, 6))
            let point = String(cString: sqlite3_column_text(stmt, 7))
            let interval = String(cString: sqlite3_column_text(stmt, 8))
            
            //adding values to list
            presetList.append(Preset(id: Int(id), name: String(describing: name), ip1: String(describing: ip1),
                                     ip2: String(describing: ip2), ip3: String(describing: ip3), ip4: String(describing: ip4), port: String(describing: port), point: String(describing: point), interval: String(describing: interval)))
        }
        
    }
    @objc func presetAction() {
        
        let alert = UIAlertController(title: "Preset name", message: "Enter preset name:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let name = textField?.text
            let ip1Data = self.ip1?.text
            let ip2Data = self.ip2?.text
            let ip3Data = self.ip3?.text
            let ip4Data = self.ip4?.text
            let portData = self.port?.text
            let pointData = self.point?.text
            let intervalData = self.interval?.text
            
            // Assuming the database file is named "database.sqlite":
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
            
            
            let insert = presets.insert(or: .replace, namet <- name!, ip1t <- ip1Data!, ip2t <- ip2Data!, ip3t <- ip3Data!, ip4t <- ip4Data!, portt <- portData!, pointt <- pointData!, intervalt <- intervalData!)
            let rowid = try! db.run(insert)
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Main functions of textfield
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
        
        ip1.text = defaults.value(forKey: "ip1Text") as? String
        ip2.text = defaults.value(forKey: "ip2Text") as? String
        ip3.text = defaults.value(forKey: "ip3Text") as? String
        ip4.text = defaults.value(forKey: "ip4Text") as? String
        port.text = defaults.value(forKey: "portText") as? String
        point.text = defaults.value(forKey: "pointText") as? String
        interval.text = defaults.value(forKey: "intervalText") as? String
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

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



