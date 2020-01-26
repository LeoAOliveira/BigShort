//
//  MenuCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 20/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var subtitle1Label: UILabel!
    @IBOutlet weak var description1Label: UILabel!
    @IBOutlet weak var subtitle2Label: UILabel!
    @IBOutlet weak var description2Label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
