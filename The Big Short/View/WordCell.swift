//
//  WordCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 02/08/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class WordCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
