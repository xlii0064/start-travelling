//
//  SearchFlightViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 26/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit

class SearchFlightViewController: UIViewController {
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var to: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var duration: UITextField!
  
    @IBOutlet weak var fromCountry: UITextField!
    @IBOutlet weak var toCountry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        date.minimumDate=Date()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
   //This function is to check if there's a spot is empty and pass the information if none of them is empty
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="searchResult"){
            let controller:WebViewController=segue.destination as! WebViewController
            
            //if some place is empty, show message box
            if (from.text!.isEmpty || to.text!.isEmpty || duration.text!.isEmpty || fromCountry.text!.isEmpty || toCountry.text!.isEmpty){
                let alert=UIAlertController(title:"Alert!",message:"You haven't filled some places",preferredStyle:UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "I know that", style: UIAlertAction.Style.default, handler:nil) )
                self.present(alert, animated: true, completion: nil)
            }
            else{
            controller.from=from.text!
            controller.to=to.text!
            var du:String
            du=duration.text!
            controller.duration=Int(du)
            controller.date=date.date
                controller.fromCountry=fromCountry.text!
                controller.toCountry=toCountry.text!
            }
        }
    }
    
    
    


}
