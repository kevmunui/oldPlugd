//
//  newestTableViewCell.swift
//  idksignin
//
//  Created by Kevin Ndiga on 7/28/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit

class newestTableViewCell: UITableViewCell {

   
   // @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var eventDay: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var placeView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var host: UILabel!
  //  @IBOutlet weak var pop: UILabel!
    
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
