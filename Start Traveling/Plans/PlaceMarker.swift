//This class was originally developed by an online tutorial which customize the placeMarker
//  PlaceMarker.swift
//  Start Traveling
//
//  Created by Xinbei Li on 14/5/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: "pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
