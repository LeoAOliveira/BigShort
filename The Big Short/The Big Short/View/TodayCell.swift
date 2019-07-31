//
//  TodayCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class TodayCell: UITableViewCell {
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var priceLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
