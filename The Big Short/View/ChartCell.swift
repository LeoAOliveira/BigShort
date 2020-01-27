//
//  ChartCell.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class ChartCell: UITableViewCell {
    
    @IBOutlet weak var sectorChart: SectorChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var description1Label: UILabel!
    
    @IBOutlet weak var color2: UIView!
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
