//
//  PlanDetailsTableViewController.swift
//  Start Traveling
//
//  Created by Xinbei Li on 30/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import CoreData

class PlanDetailsTableViewController: UITableViewController {
    var plan:Plan?
    var databaseController: DatabaseProtocol?
    var cities=[Cities]()
    //func to handle share button
    @IBAction func share(_ sender: Any) {
        pdfDataWithTableView(tableView: tableView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title=plan!.tittle

        cities = plan?.cities?.allObjects as! [Cities]
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }
    
    //This func would generate a table view into a pdf file and was developed online
    func pdfDataWithTableView(tableView: UITableView) {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let name=(plan?.tittle)!+".pdf"
        docURL = docURL.appendingPathComponent(name)
        pdfData.write(to: docURL as URL, atomically: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let cityCell:PlanDetailsTableViewCell=cell as! PlanDetailsTableViewCell
        cityCell.city.text=cities[indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    //this function would pass the plan and city name to next next table view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="sights"){
            let controller:SightCityTableViewController=segue.destination as! SightCityTableViewController
            let selectedIndexPath = tableView.indexPathsForSelectedRows?.first
            controller.city = cities[selectedIndexPath!.row]
            controller.plan=plan
        }
    }
   

}
