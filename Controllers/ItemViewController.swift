//
//  ItemViewController.swift
//  TruequeApp
//
//  Created by Alumnos on 6/23/18.
//  Copyright © 2018 UPC. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var myItem : Item = Item()
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(myItem.name+"->"+myItem.itemDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.lbName.text = myItem.name
        self.lbDescription.text = myItem.itemDescription
    }

    
    // MARK: - Navigation

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
     */

}
