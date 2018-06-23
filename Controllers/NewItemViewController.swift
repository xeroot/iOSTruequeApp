//
//  NewItemViewController.swift
//  TruequeApp
//
//  Created by Alumnos on 6/2/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    //Variables
    var categoriesArray = [ItemCategory]()
    
    //Outlets
    @IBOutlet weak var pkrCategories: UIPickerView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtReferencialValue: UITextField!
    @IBOutlet weak var swtTradable: UISwitch!
    
    //Picker methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoriesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoriesArray[row].categoryDescription
    }
    
    //Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pkrCategories.delegate = self
        pkrCategories.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request("http://vmdev1.nexolink.com:90/TruequeAppAPI/api/ItemCategoriesApp").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
                //Read json
                let sJson = JSON(json)
                
                for (_,subJson):(String, JSON) in sJson {
                    // Do something you want
                    let objCategory = ItemCategory()
                    objCategory.categoryDescription = subJson["Description"].stringValue
                    objCategory.id = subJson["Id"].intValue
                    self.categoriesArray.append(objCategory)
                }
            }
            
            self.pkrCategories.reloadAllComponents()
            /*if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
             print("Data: \(utf8Text)") // original server data as UTF8 string
             }*/
        }
    }
    
    //Button actions
    @IBAction func btnSavePressed(_ sender: Any) {
        
        //Get category
        var categoryId = 0
        let objCategory : ItemCategory = self.categoriesArray[self.pkrCategories.selectedRow(inComponent: 0)]
        categoryId = objCategory.id
        
        //Get user
        let userDefaults = UserDefaults.standard
        let userId : Int = userDefaults.integer(forKey: "UserId")
        
        //Set parameters
        let parameters : Parameters = ["Name" : self.txtName.text!, "Description" : self.txtDescription.text!, "ReferencialValue" : Double(self.txtReferencialValue.text!) ?? 0, "Tradable" : self.swtTradable.isOn, "Status" : "Created", "UserId" : userId, "CategoryId" : categoryId]
        
        Alamofire.request("http://vmdev1.nexolink.com:90/TruequeAppAPI/api/Items", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            print("Result Value: \(String(describing: response.result.value))")               // response serialization result
            
            switch(response.result){
            case .failure(_):
                    let alert = UIAlertController(title: "Fail!", message: "Something went wrong! Please try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break;
                case .success:                    self.navigationController?.popViewController(animated: true)
                    break;
            }
            
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
