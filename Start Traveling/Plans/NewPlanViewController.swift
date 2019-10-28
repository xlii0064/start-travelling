//
//  NewPlanViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 4/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData

class NewPlanViewController: UIViewController {
    @IBOutlet weak var tittle: UITextField!
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var startDate: UIDatePicker!
    var databaseController: DatabaseProtocol?
    var plans=[Plan]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        loadData()
        startDate.minimumDate=Date()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
    }
    
    
    //This func would display a message box to inform whether the user has saved the plan successfully or not
    func display(title:String,message:String,actionBtn:String){
        let alert=UIAlertController(title:title,message:message,preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionBtn, style: UIAlertAction.Style.default, handler:nil) )
       
        self.present(alert, animated: true, completion: nil)
    }
    
    //load all the plans from database to compare
    func loadData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Plan")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                plans.append(data as! Plan)
            }
            
        } catch {
            
            print("Failed")
        }
        
        appDelegate.saveContext()
    }
    
    
   

    //this func would check if some place is empty or if the plan name already exist
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="chooseCities"{
            let name=tittle.text!
            var duplicate=false
            for plan in plans{
                //the names must be identical. if there's redundant, report error
                if (plan.tittle==name){
                    let alert=UIAlertController(title:"Warning!",message:"You already have a plan with the same name.",preferredStyle:UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler:nil) )
                    self.present(alert, animated: true, completion: nil)
                    duplicate=true
                }
            }
            if (!duplicate){
            let theAuthor=author.text!
            let start=startDate.date
            //there should not be an empty place. If there is, report it
            if (name.isEmpty) || (theAuthor.isEmpty){
                let alert=UIAlertController(title:"Warning!",message:"You haven't filled some places",preferredStyle:UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "I know that", style: UIAlertAction.Style.default, handler:nil) )
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let plan=databaseController!.addPlan(tittle: name, author: theAuthor, start: start)
                let controller:ChooseCitiesTableViewController=segue.destination as! ChooseCitiesTableViewController
                controller.plan=plan
            }
        }
        }
    }
    
}
extension UIViewController {
    //the following 2 functions were found online to close the keyboard when not needed
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
