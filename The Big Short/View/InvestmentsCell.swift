//
//  InvestmentsCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 15/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class InvestmentsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var vizualizeButton: UIButton!
    
    @IBOutlet weak var marketView: UIView!
    @IBOutlet weak var marketLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
