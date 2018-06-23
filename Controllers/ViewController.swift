//
//  ViewController.swift
//  TruequeApp
//
//  Created by Alumnos on 5/28/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnLoginPressed(_ sender: Any) {
        //Validate login
        Alamofire.request("http://vmdev1.nexolink.com:90/TruequeAppAPI/api/UsersApp?username=" + txtUserName.text! + "&password=" + txtPassword.text!).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
            
            let sJson = JSON(response.result.value)
            if(sJson["Id"] != JSON.null){
                print(sJson["Id"])
                print(sJson["Name"])
                print(sJson["Rating"])
                print(sJson["UserName"])
                
                let userDefaults = UserDefaults.standard
                userDefaults.set(sJson["Id"].intValue, forKey: "UserId")
                
                self.performSegue(withIdentifier: "login", sender: nil)
            }
            else{
                let alert = UIAlertController(title: "Fail!", message: "Invalid credentials!", preferredStyle: UIAlertControllerStyle.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

