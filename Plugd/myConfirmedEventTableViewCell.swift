//
//  myConfirmedEventTableViewCell.swift
//  idksignin
//
//  Created by Kevin Ndiga on 8/3/15.
//  Copyright (c) 2015 TechtownLabs. All rights reserved.
//

import UIKit

class myConfirmedEventTableViewCell: UITableViewCell {

   // @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var partyName: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var datetogo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
