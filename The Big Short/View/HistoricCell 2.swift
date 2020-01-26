//
//  HistoricCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 31/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class HistoricCell: UITableViewCell {
    
    @IBOutlet weak var histView: UIView!
    @IBOutlet weak var histSubView: UIView!
    @IBOutlet weak var totalChangeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var mediumPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
