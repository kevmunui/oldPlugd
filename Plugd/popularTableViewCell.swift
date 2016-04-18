//
//  popularTableViewCell.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/4/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit

class popularTableViewCell: UITableViewCell {

    @IBOutlet weak var eventDay: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var time: UILabel!
   // @IBOutlet weak var numb: UILabel!
    //@IBOutlet weak var eventType: UILabel!
    var receiver: String = ""

  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
