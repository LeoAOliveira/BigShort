//
//  CurrencyCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 22/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var currencyView: UIView!
    @IBOutlet weak var currencySubview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyValueLabel: UILabel!
    @IBOutlet weak var variationValueLabel: UILabel!
    @IBOutlet weak var variationLabel: UILabel!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mediumValueLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
