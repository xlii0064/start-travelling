//
//  SetOrderTableViewCell.swift
//  Start Traveling
//
//  Created by Xinbei Li on 7/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit

class SetOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    var cityName:String?
    
    @IBOutlet weak var button: UIButton!
    weak var parent: UIViewController?
    var indexPath: IndexPath?
    
    //when this func was tapped, it would reset the vaule of mapCityName to pass the city name that the user would like to choose
    //sight from
    @IBAction func tapped(_ sender: Any) {
        print(cityName!)
        //pass city name to map
        UserDefaults.standard.set(cityName!,forKey: "mapCityName")
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
