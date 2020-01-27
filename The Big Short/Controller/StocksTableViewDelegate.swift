//
//  StocksTableViewDelegate.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 17/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

class StocksTableViewDelegate: NSObject, UITableViewDelegate {
    
    weak var stocksViewController: StocksViewController?
    
    init(viewController: StocksViewController) {
        stocksViewController = viewController
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 220
            
        } else if indexPath.row == 1 {
            
            guard let stocksVC = stocksViewController else {
                return 180
            }
            
            let stockList = stocksVC.stockList.count
            
            let cells: Double = (Double(stockList) + 1.0) / 3.0
            
            let rows: Int = Int(cells.rounded(.up)) - 1
            
            return CGFloat(180 + (rows * 145))
        
        } else {
            return 80
        }
    }
}
