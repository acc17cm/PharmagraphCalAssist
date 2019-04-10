//
//  PresetViewController.swift
//  Pharmagraph
//
//  Created by Cameron McWilliam on 21/08/2018.
//  Copyright © 2018 Cameron McWilliam. All rights reserved.
//
import Foundation
import UIKit
import SwiftSocket
import SQLite

var customerName: String!
var siteName: String!
var systemName: String!

class PresetViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var entries : [String]?
    
    var table : UITableView!
    var dbP : OpaquePointer?
    var presetList = [Preset]()
    var timeout: UInt32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeout = 100000
        
        view.backgroundColor = UIColor.white
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("db.sqlite3")
        
        if sqlite3_open(fileURL.path, &dbP) != SQLITE_OK {
            print("error opening database")
        }
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        table = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        table.dataSource = self
        table.delegate = self
        readValues()
        view.addSubview(table)
        
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //this method is giving the row count of table view which is
        //total number of heroes in the list
        return presetList.count
    }
    
    
    //this method is binding the hero name with the tableview cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "MyCell")
        let preset: Preset
        preset = presetList[indexPath.row]
        cell.textLabel?.text = preset.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let defaults = UserDefaults.standard
        let preset: Preset
        preset = presetList[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabBar = appDelegate.tabBarController
        defaults.set(preset.name, forKey: "name")
        defaults.set(preset.ip1, forKey: "ip1Text")
        defaults.set(preset.ip2, forKey: "ip2Text")
        defaults.set(preset.ip3, forKey: "ip3Text")
        defaults.set(preset.ip4, forKey: "ip4Text")
        defaults.set(preset.port, forKey: "portText")
        defaults.set(preset.point, forKey: "pointText")
        defaults.set(preset.interval, forKey: "intervalText")
        let ip1 = defaults.value(forKey: "ip1Text") as? String
        let ip2 = defaults.value(forKey: "ip2Text") as? String
        let ip3 = defaults.value(forKey: "ip3Text") as? String
        let ip4 = defaults.value(forKey: "ip4Text") as? String
        let port = defaults.value(forKey: "portText") as? String
        let ip1String = ip1!
        let ip2String = ip2!
        let ip3String = ip3!
        let ip4String = ip4!
        let portString = port!
        let ip1Num = Int(ip1String)
        let ip2Num = Int(ip2String)
        let ip3Num = Int(ip3String)
        let ip4Num = Int(ip4String)
        let portNum = Int32(portString)
        
        if portNum != 49008 {   //CHEATED FOR DEMO!!!
            
            tabBar?.selectedIndex = 0
            customerName = ""
            siteName = ""
            systemName = ""
            
        }
        
        else {
        
        let client = TCPClient(address: "\(ip1Num!).\(ip2Num!).\(ip3Num!).\(ip4Num!)", port: portNum!)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?0\r" ) {
            case .success:
                usleep(self.timeout)
                guard let data = client.read(1024*10)
                    else {
                        client.close()
                        return
                }
                
                
                if let response = String(bytes: data, encoding: .utf8) {
                
                let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                let responseString = response[...indexEndOfText]
                customerName = String(responseString)
                }
                
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?1\r" ) {
            case .success:
                usleep(self.timeout)
                guard let data = client.read(1024*10)
                    else {
                        client.close()
                        return
                }
                
                
                if let response = String(bytes: data, encoding: .utf8) {
                
                let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                let responseString = response[...indexEndOfText]
                siteName = String(responseString)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "?2\r" ) {
            case .success:
                usleep(self.timeout)
                guard let data = client.read(1024*10)
                    else {
                        client.close()
                        return
                }
                
                
                if let response = String(bytes: data, encoding: .utf8) {
                
                let indexEndOfText = response.index(response.endIndex, offsetBy: -3)
                let responseString = response[...indexEndOfText]
                systemName = String(responseString)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        tabBar?.selectedIndex = 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")
            let defaults = UserDefaults.standard
            let preset: Preset
            preset = self.presetList[indexPath.row]
            defaults.set(preset.name, forKey: "name")
            defaults.set(preset.ip1, forKey: "ip1Text")
            defaults.set(preset.ip2, forKey: "ip2Text")
            defaults.set(preset.ip3, forKey: "ip3Text")
            defaults.set(preset.ip4, forKey: "ip4Text")
            defaults.set(preset.port, forKey: "portText")
            defaults.set(preset.point, forKey: "pointText")
            defaults.set(preset.interval, forKey: "intervalText")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBar = appDelegate.tabBarController
            tabBar?.selectedIndex = 1
        }
        
        
        
        edit.backgroundColor = UIColor.lightGray
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("delete button tapped")
            let preset: Preset
            preset = self.presetList[indexPath.row]
            if sqlite3_exec(self.dbP, "DELETE FROM presets WHERE id = \(preset.id)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(self.dbP)!)
                print("error deleting table: \(errmsg)")
            }
            self.presetList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, edit]
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
        
          self.table.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readValues()
        self.table.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
