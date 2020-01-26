//
//  PositionCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 26/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class PositionCell: UITableViewCell {
    
    @IBOutlet weak var positionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var investedValueLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeValueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
