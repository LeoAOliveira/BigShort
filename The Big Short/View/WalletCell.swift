//
//  WalletCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 15/07/19.
//  Copyright © 2019 Leonardo Oliveira. All rights reserved.
//

import UIKit

class WalletCell: UITableViewCell {
    
    @IBOutlet weak var walletView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    
    @IBOutlet weak var percentageView: UIView!
    
    @IBOutlet weak var stocksPercentageLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!
    
    @IBOutlet weak var publicTitlesPercentageLabel: UILabel!
    @IBOutlet weak var publicTitlesLabel: UILabel!
    
    @IBOutlet weak var dollarPercentageLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    
    @IBOutlet weak var savingsPercentageLabel: UILabel!
    @IBOutlet weak var savingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
