//
//  ButtonCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 21/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    
    @IBOutlet weak var button: CustomButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
