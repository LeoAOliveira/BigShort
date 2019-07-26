//
//  WalletCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 15/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class SimulatorCell: UITableViewCell {
    
    @IBOutlet weak var walletView: UIView!
    @IBOutlet weak var investmentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
