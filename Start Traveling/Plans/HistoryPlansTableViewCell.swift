
//
//  HistoryPlansTableViewCell.swift
//  Start Traveling
//
//  Created by Xinbei Li on 30/4/19.
//  Copyright © 2019 Xinbei Li. All rights reserved.
//

import UIKit

class HistoryPlansTableViewCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
